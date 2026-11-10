-- DATABASE WEEK 8
-- V4: Row-Level Security
-- Real-Time Analytics Platform

-- 1. Create a restricted application role
CREATE ROLE capstone_app NOLOGIN;

-- 2. Allow the application role to use the public schema
GRANT USAGE ON SCHEMA public TO capstone_app;

-- 3. Grant access to application tables.
-- The audit_logs table is deliberately excluded.
GRANT SELECT, INSERT, UPDATE, DELETE
ON tenants, users, sessions, events, subscriptions, payments
TO capstone_app;

-- Shared reference tables can be read by all tenants
GRANT SELECT ON event_types, plans TO capstone_app;

-- Allow the application role to use table identity sequences
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public
TO capstone_app;

-- 4. Enable Row-Level Security
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- 5. Tenant policy
CREATE POLICY tenant_isolation_tenants
ON tenants
FOR ALL
TO capstone_app
USING (
    tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
)
WITH CHECK (
    tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
);

-- 6. Users policy
CREATE POLICY tenant_isolation_users
ON users
FOR ALL
TO capstone_app
USING (
    tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
)
WITH CHECK (
    tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
);

-- 7. Sessions policy
-- A session belongs to the tenant that owns its user.
CREATE POLICY tenant_isolation_sessions
ON sessions
FOR ALL
TO capstone_app
USING (
    EXISTS (
        SELECT 1
        FROM users
        WHERE users.user_id = sessions.user_id
          AND users.tenant_id =
              NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM users
        WHERE users.user_id = sessions.user_id
          AND users.tenant_id =
              NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
    )
);

-- 8. Events policy
CREATE POLICY tenant_isolation_events
ON events
FOR ALL
TO capstone_app
USING (
    tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
)
WITH CHECK (
    tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
);

-- 9. Subscriptions policy
CREATE POLICY tenant_isolation_subscriptions
ON subscriptions
FOR ALL
TO capstone_app
USING (
    tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
)
WITH CHECK (
    tenant_id = NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
);

-- 10. Payments policy
-- A payment belongs to the tenant that owns its subscription.
CREATE POLICY tenant_isolation_payments
ON payments
FOR ALL
TO capstone_app
USING (
    EXISTS (
        SELECT 1
        FROM subscriptions
        WHERE subscriptions.subscription_id = payments.subscription_id
          AND subscriptions.tenant_id =
              NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM subscriptions
        WHERE subscriptions.subscription_id = payments.subscription_id
          AND subscriptions.tenant_id =
              NULLIF(current_setting('app.tenant_id', true), '')::INTEGER
    )
);

-- 11. Protect audit logging when the application role changes records.
-- The trigger function runs with its owner's privileges so the
-- application role does not need direct access to audit_logs.
ALTER FUNCTION record_audit_changes() SECURITY DEFINER;

ALTER FUNCTION record_audit_changes()
SET search_path = pg_catalog, public;