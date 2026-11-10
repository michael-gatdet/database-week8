import redis
import json

# Connect to Redis
r = redis.Redis(
    host="localhost",
    port=6379,
    decode_responses=True
)

# Remove the malformed test event
r.xdel("capstone:events:ingest", "1794297819220-0")

# Prepare a valid event
event = {
    "tenant_id": "4",
    "user_id": "4",
    "event_type_id": "1",
    "session_id": "1",
    "occurred_at": "2026-11-01T09:15:00+03:00",
    "properties": json.dumps({
        "source": "redis_stream",
        "device": "web"
    })
}

# Add the corrected event
event_id = r.xadd("capstone:events:ingest", event)

print("Corrected event ID:", event_id)
print("Properties:", event["properties"])