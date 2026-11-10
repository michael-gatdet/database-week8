-- DATABASE WEEK 8
-- V5: Seed Demo Data
-- Real-Time Analytics Platform

-- 1. Create two sample organisations
INSERT INTO tenants (tenant_name)
VALUES
    ('Acme Analytics'),
    ('Blue Sky Retail')
ON CONFLICT (tenant_name) DO NOTHING;


-- 2. Create event types
INSERT INTO event_types (event_name)
VALUES
    ('page_view'),
    ('signup'),
    ('add_to_cart'),
    ('purchase')
ON CONFLICT (event_name) DO NOTHING;


-- 3. Create subscription plans
INSERT INTO plans (plan_name, monthly_price)
VALUES
    ('Starter', 29.00),
    ('Growth', 99.00),
    ('Enterprise', 299.00)
ON CONFLICT (plan_name) DO NOTHING;


-- 4. Create sample users for Acme Analytics
INSERT INTO users (tenant_id, full_name, email)
SELECT tenant_id, sample.full_name, sample.email
FROM tenants
CROSS JOIN (
    VALUES
        ('Maya Johnson', 'maya@acme.example.test'),
        ('Liam Smith', 'liam@acme.example.test'),
        ('Ava Brown', 'ava@acme.example.test')
) AS sample(full_name, email)
WHERE tenant_name = 'Acme Analytics'
ON CONFLICT (tenant_id, email) DO NOTHING;


-- 5. Create sample users for Blue Sky Retail
INSERT INTO users (tenant_id, full_name, email)
SELECT tenant_id, sample.full_name, sample.email
FROM tenants
CROSS JOIN (
    VALUES
        ('Emma Davis', 'emma@bluesky.example.test'),
        ('Noah Wilson', 'noah@bluesky.example.test')
) AS sample(full_name, email)
WHERE tenant_name = 'Blue Sky Retail'
ON CONFLICT (tenant_id, email) DO NOTHING;


-- 6. Create one sample session for each demo user
INSERT INTO sessions (user_id, started_at, ended_at)
SELECT
    u.user_id,
    TIMESTAMPTZ '2026-11-01 09:00:00+03',
    TIMESTAMPTZ '2026-11-01 09:30:00+03'
FROM users u
JOIN tenants t ON t.tenant_id = u.tenant_id
WHERE t.tenant_name IN ('Acme Analytics', 'Blue Sky Retail')
  AND u.email IN (
      'maya@acme.example.test',
      'liam@acme.example.test',
      'ava@acme.example.test',
      'emma@bluesky.example.test',
      'noah@bluesky.example.test'
  )
  AND NOT EXISTS (
      SELECT 1
      FROM sessions s
      WHERE s.user_id = u.user_id
  );


-- 7. Create subscriptions for both organisations
INSERT INTO subscriptions (tenant_id, plan_id, start_date, status)
SELECT t.tenant_id, p.plan_id, DATE '2026-11-01', 'active'
FROM tenants t
JOIN plans p ON p.plan_name = 'Growth'
WHERE t.tenant_name = 'Acme Analytics'
  AND NOT EXISTS (
      SELECT 1 FROM subscriptions s
      WHERE s.tenant_id = t.tenant_id
  );

INSERT INTO subscriptions (tenant_id, plan_id, start_date, status)
SELECT t.tenant_id, p.plan_id, DATE '2026-11-02', 'active'
FROM tenants t
JOIN plans p ON p.plan_name = 'Starter'
WHERE t.tenant_name = 'Blue Sky Retail'
  AND NOT EXISTS (
      SELECT 1 FROM subscriptions s
      WHERE s.tenant_id = t.tenant_id
  );


-- 8. Record sample payments
INSERT INTO payments (subscription_id, amount, currency, paid_at)
SELECT s.subscription_id, 99.00, 'USD',
       TIMESTAMPTZ '2026-11-01 10:00:00+03'
FROM subscriptions s
JOIN tenants t ON t.tenant_id = s.tenant_id
WHERE t.tenant_name = 'Acme Analytics'
  AND NOT EXISTS (
      SELECT 1 FROM payments p
      WHERE p.subscription_id = s.subscription_id
  );

INSERT INTO payments (subscription_id, amount, currency, paid_at)
SELECT s.subscription_id, 29.00, 'USD',
       TIMESTAMPTZ '2026-11-02 11:00:00+03'
FROM subscriptions s
JOIN tenants t ON t.tenant_id = s.tenant_id
WHERE t.tenant_name = 'Blue Sky Retail'
  AND NOT EXISTS (
      SELECT 1 FROM payments p
      WHERE p.subscription_id = s.subscription_id
  );


-- 9. Insert sample activity events
-- All event timestamps fall within November 2026.

INSERT INTO events (
    occurred_at,
    tenant_id,
    user_id,
    event_type_id,
    session_id,
    properties
)
SELECT
    sample.occurred_at,
    t.tenant_id,
    u.user_id,
    et.event_type_id,
    s.session_id,
    sample.properties::JSONB
FROM (
    VALUES
    ('Acme Analytics', 'maya@acme.example.test', 'page_view',
     TIMESTAMPTZ '2026-11-01 09:01:00+03',
     '{"page":"/home"}'),

    ('Acme Analytics', 'maya@acme.example.test', 'signup',
     TIMESTAMPTZ '2026-11-01 09:05:00+03',
     '{"method":"email"}'),

    ('Acme Analytics', 'maya@acme.example.test', 'add_to_cart',
     TIMESTAMPTZ '2026-11-02 10:00:00+03',
     '{"product":"Analytics Pro"}'),

    ('Acme Analytics', 'maya@acme.example.test', 'purchase',
     TIMESTAMPTZ '2026-11-02 10:10:00+03',
     '{"amount":99,"currency":"USD"}'),

    ('Acme Analytics', 'liam@acme.example.test', 'page_view',
     TIMESTAMPTZ '2026-11-03 11:00:00+03',
     '{"page":"/pricing"}'),

    ('Acme Analytics', 'liam@acme.example.test', 'signup',
     TIMESTAMPTZ '2026-11-04 11:15:00+03',
     '{"method":"google"}'),

    ('Acme Analytics', 'ava@acme.example.test', 'page_view',
     TIMESTAMPTZ '2026-11-04 12:00:00+03',
     '{"page":"/home"}'),

    ('Acme Analytics', 'ava@acme.example.test', 'page_view',
     TIMESTAMPTZ '2026-11-08 12:00:00+03',
     '{"page":"/dashboard"}'),

    ('Blue Sky Retail', 'emma@bluesky.example.test', 'page_view',
     TIMESTAMPTZ '2026-11-01 10:00:00+03',
     '{"page":"/shop"}'),

    ('Blue Sky Retail', 'emma@bluesky.example.test', 'signup',
     TIMESTAMPTZ '2026-11-01 10:05:00+03',
     '{"method":"email"}'),

    ('Blue Sky Retail', 'emma@bluesky.example.test', 'purchase',
     TIMESTAMPTZ '2026-11-03 10:30:00+03',
     '{"amount":29,"currency":"USD"}'),

    ('Blue Sky Retail', 'noah@bluesky.example.test', 'page_view',
     TIMESTAMPTZ '2026-11-02 14:00:00+03',
     '{"page":"/shop"}'),

    ('Blue Sky Retail', 'noah@bluesky.example.test', 'add_to_cart',
     TIMESTAMPTZ '2026-11-02 14:10:00+03',
     '{"product":"Running Shoes"}'),

    ('Blue Sky Retail', 'noah@bluesky.example.test', 'purchase',
     TIMESTAMPTZ '2026-11-05 14:30:00+03',
     '{"amount":29,"currency":"USD"}'),

    ('Blue Sky Retail', 'noah@bluesky.example.test', 'page_view',
     TIMESTAMPTZ '2026-11-08 14:00:00+03',
     '{"page":"/offers"}')
) AS sample(
    tenant_name,
    email,
    event_name,
    occurred_at,
    properties
)
JOIN tenants t
    ON t.tenant_name = sample.tenant_name
JOIN users u
    ON u.tenant_id = t.tenant_id
   AND u.email = sample.email
JOIN event_types et
    ON et.event_name = sample.event_name
JOIN sessions s
    ON s.user_id = u.user_id;