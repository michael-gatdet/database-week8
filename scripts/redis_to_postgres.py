
import redis
import psycopg
import json
import getpass
from psycopg.types.json import Jsonb

# Redis Stream configuration
STREAM_NAME = "capstone:events:ingest"
GROUP_NAME = "capstone-postgres"
CONSUMER_NAME = "windows-consumer-1"

# Connect to Redis (Memurai)
r = redis.Redis(
    host="localhost",
    port=6379,
    decode_responses=True
)

# Ask for the PostgreSQL password securely
password = getpass.getpass("Enter PostgreSQL password: ")

# Connect to PostgreSQL
conn = psycopg.connect(
    host="localhost",
    port=5432,
    dbname="capstone",
    user="postgres",
    password=password
)

try:
    # Create a consumer group.
    # Starting at 0 allows the group to receive existing stream events.
    try:
        r.xgroup_create(
            STREAM_NAME,
            GROUP_NAME,
            id="0",
            mkstream=True
        )
        print("Redis consumer group created.")
    except redis.exceptions.ResponseError as error:
        if "BUSYGROUP" in str(error):
            print("Redis consumer group already exists.")
        else:
            raise

    # Read up to 10 new messages
    messages = r.xreadgroup(
        GROUP_NAME,
        CONSUMER_NAME,
        {STREAM_NAME: ">"},
        count=10,
        block=1000
    )

    if not messages:
        print("No new Redis events to process.")

    for stream, entries in messages:
        for redis_id, fields in entries:
            try:
                # Extract and convert event data
                tenant_id = int(fields["tenant_id"])
                user_id = int(fields["user_id"])
                event_type_id = int(fields["event_type_id"])
                session_id = int(fields["session_id"])
                occurred_at = fields["occurred_at"]
                properties = json.loads(fields.get("properties", "{}"))

                # Insert event into PostgreSQL
                with conn.cursor() as cur:
                    cur.execute(
                        """
                        INSERT INTO events (
                            occurred_at,
                            tenant_id,
                            user_id,
                            event_type_id,
                            session_id,
                            properties,
                            redis_stream_id
                        )
                        VALUES (%s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (redis_stream_id, occurred_at)
                        DO NOTHING;
                        """,
                        (
                            occurred_at,
                            tenant_id,
                            user_id,
                            event_type_id,
                            session_id,
                            Jsonb(properties),
                            redis_id
                        )
                    )
                    inserted = cur.rowcount

                # Commit the database transaction before acknowledging
                conn.commit()

                # Acknowledge the Redis message after successful commit
                r.xack(STREAM_NAME, GROUP_NAME, redis_id)

                if inserted:
                    print(f"Inserted event {redis_id} into PostgreSQL.")
                else:
                    print(f"Duplicate event {redis_id} skipped safely.")

            except Exception as error:
                conn.rollback()
                print(f"Could not process event {redis_id}: {error}")
                print("Message remains unacknowledged for investigation.")

finally:
    conn.close()
    print("PostgreSQL connection closed.")
