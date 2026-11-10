-- DATABASE WEEK 8
-- V2: Indexes for Query Performance
-- Real-Time Analytics Platform

-- BRIN index for time-based event searches
CREATE INDEX idx_events_occurred_at_brin
ON events USING BRIN (occurred_at)
WITH (pages_per_range = 64);

-- B-tree indexes for event filtering and joins
CREATE INDEX idx_events_tenant_time
ON events (tenant_id, occurred_at);

CREATE INDEX idx_events_user_time
ON events (user_id, occurred_at);

CREATE INDEX idx_events_type_time
ON events (event_type_id, occurred_at);

CREATE INDEX idx_events_session
ON events (session_id);

-- Session lookup
CREATE INDEX idx_sessions_user_started
ON sessions (user_id, started_at);

-- Subscription reporting
CREATE INDEX idx_subscriptions_tenant_status
ON subscriptions (tenant_id, status);

-- Payment reporting
CREATE INDEX idx_payments_paid_at
ON payments (paid_at);

CREATE INDEX idx_payments_subscription
ON payments (subscription_id);