-- DATABASE WEEK 8
-- V6: Analytics Materialized Views
-- Real-Time Analytics Platform

-- 1. Create a daily event summary for the analytics dashboard.
CREATE MATERIALIZED VIEW mv_daily_event_summary AS
SELECT
    e.tenant_id,
    (e.occurred_at AT TIME ZONE 'UTC')::DATE AS event_date,
    e.event_type_id,
    et.event_name,
    COUNT(*) AS total_events,
    COUNT(DISTINCT e.user_id) AS unique_users,
    COUNT(DISTINCT e.session_id) AS unique_sessions
FROM events e
JOIN event_types et
    ON et.event_type_id = e.event_type_id
GROUP BY
    e.tenant_id,
    (e.occurred_at AT TIME ZONE 'UTC')::DATE,
    e.event_type_id,
    et.event_name
WITH DATA;

-- 2. Create a unique index for the summary rows.
CREATE UNIQUE INDEX idx_mv_daily_event_summary_key
ON mv_daily_event_summary (
    tenant_id,
    event_date,
    event_type_id
);

-- 3. Create an index to support date-based dashboard filtering.
CREATE INDEX idx_mv_daily_event_summary_date
ON mv_daily_event_summary (event_date);