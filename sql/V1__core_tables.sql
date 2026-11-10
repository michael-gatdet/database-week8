-- DATABASE WEEK 8
-- V1: Core Tables
-- Real-Time Analytics Platform

-- 1. Tenants
CREATE TABLE tenants (
    tenant_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tenant_name VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Users
CREATE TABLE users (
    user_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tenant_id INT NOT NULL REFERENCES tenants(tenant_id),
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (tenant_id, email)
);

-- 3. Event types
CREATE TABLE event_types (
    event_type_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Sessions
CREATE TABLE sessions (
    session_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ
);

-- 5. Events (partitioned by time)
CREATE TABLE events (
    event_id BIGINT GENERATED ALWAYS AS IDENTITY,
    occurred_at TIMESTAMPTZ NOT NULL,
    tenant_id INT NOT NULL REFERENCES tenants(tenant_id),
    user_id INT NOT NULL REFERENCES users(user_id),
    event_type_id INT NOT NULL REFERENCES event_types(event_type_id),
    session_id BIGINT REFERENCES sessions(session_id),
    properties JSONB NOT NULL DEFAULT '{}'::jsonb,
    PRIMARY KEY (event_id, occurred_at)
) PARTITION BY RANGE (occurred_at);

-- Monthly event partitions
CREATE TABLE events_2026_11
PARTITION OF events
FOR VALUES FROM ('2026-11-01') TO ('2026-12-01');

CREATE TABLE events_2026_12
PARTITION OF events
FOR VALUES FROM ('2026-12-01') TO ('2027-01-01');

CREATE TABLE events_2027_01
PARTITION OF events
FOR VALUES FROM ('2027-01-01') TO ('2027-02-01');

-- Default partition for other dates
CREATE TABLE events_default
PARTITION OF events DEFAULT;

-- 6. Plans
CREATE TABLE plans (
    plan_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL UNIQUE,
    monthly_price NUMERIC(12,2) NOT NULL CHECK (monthly_price >= 0)
);

-- 7. Subscriptions
CREATE TABLE subscriptions (
    subscription_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tenant_id INT NOT NULL REFERENCES tenants(tenant_id),
    plan_id INT NOT NULL REFERENCES plans(plan_id),
    start_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL
        CHECK (status IN ('active', 'cancelled', 'expired'))
);

-- 8. Payments
CREATE TABLE payments (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    subscription_id BIGINT NOT NULL
        REFERENCES subscriptions(subscription_id),
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    currency CHAR(3) NOT NULL,
    paid_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);