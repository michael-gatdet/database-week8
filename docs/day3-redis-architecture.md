

\# Database Week 8 - Real-Time Analytics Platform



\## Day 3: Redis Streams Architecture



\### 1. Introduction



The Real-Time Analytics Platform uses Redis Streams as an ingestion buffer before PostgreSQL. Memurai, a Redis-compatible service for Windows, was used to implement and test the Redis Stream.



Python connects Redis to PostgreSQL using the Redis and Psycopg packages.



\### 2. Architecture and Data Flow



Application / Event Producer

&#x20;       |

&#x20;       v

Redis Stream (Memurai)

&#x20;       |

&#x20;       v

Python Consumer

&#x20;       |

&#x20;       v

PostgreSQL Events Table

&#x20;       |

&#x20;       v

Materialized Analytics Views

&#x20;       |

&#x20;       v

Analytics Dashboard



\### 3. How the System Works



1\. An application generates an event, such as a page view, signup, or purchase.

2\. The event is added to the Redis Stream.

3\. The Python consumer reads the event from Redis.

4\. The consumer validates and converts the event data.

5\. The event is inserted into the PostgreSQL events table.

6\. PostgreSQL commits the transaction.

7\. The consumer acknowledges the Redis message.

8\. Materialized views summarize event data for analytics dashboards.



\### 4. Why Redis Streams Was Selected



Redis Streams was selected because:



\- It can buffer incoming events before database insertion.

\- It separates event production from database processing.

\- It supports consumer groups for distributing message processing.

\- It provides message IDs and acknowledgement.

\- It supports recovery of messages that have not been acknowledged.



\### 5. Duplicate Protection



The V7 migration added the redis\_stream\_id column to the events table.



It also created a unique index on:



(redis\_stream\_id, occurred\_at)



The Python consumer uses ON CONFLICT DO NOTHING to prevent duplicate event insertion.



The duplicate test returned INSERT 0 0, and the event count remained one.



\### 6. Tools Used



\- Memurai: Redis-compatible Windows service.

\- Redis Streams: Event ingestion and buffering.

\- Python: Event processing.

\- Redis Python package: Redis communication.

\- Psycopg: PostgreSQL communication.

\- PostgreSQL 18.6: Main database.

\- Flyway: Database schema versioning.



\### 7. Conclusion



The Day 3 integration successfully demonstrated how Redis Streams can receive activity events and how a Python consumer transfers them into PostgreSQL.



The test confirmed successful insertion, message acknowledgement, and duplicate protection.



For production use, the platform would also need stronger monitoring, pending-message recovery, secure service credentials, and appropriate consumer scaling.



