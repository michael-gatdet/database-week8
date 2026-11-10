-- DATABASE WEEK 8
-- V7: Redis Streams Integration
-- Real-Time Analytics Platform

-- Store the original Redis Stream ID for each ingested event.
ALTER TABLE events
ADD COLUMN redis_stream_id TEXT;

-- Prevent the same Redis event from being inserted twice.
-- The partition key occurred_at must be included in this unique index.
CREATE UNIQUE INDEX idx_events_redis_stream_id
ON events (redis_stream_id, occurred_at);