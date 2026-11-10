-- DATABASE WEEK 8
-- V3: Audit Logs and Triggers
-- Real-Time Analytics Platform

-- 1. Create audit log table
CREATE TABLE audit_logs (
    audit_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id TEXT NOT NULL,
    operation VARCHAR(10) NOT NULL
        CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
    old_data JSONB,
    new_data JSONB,
    changed_by TEXT NOT NULL DEFAULT SESSION_USER,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Create a reusable audit trigger function
CREATE OR REPLACE FUNCTION record_audit_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    old_record JSONB;
    new_record JSONB;
    affected_record_id TEXT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        new_record := TO_JSONB(NEW);
        affected_record_id := new_record ->> TG_ARGV[0];

    ELSIF TG_OP = 'UPDATE' THEN
        old_record := TO_JSONB(OLD);
        new_record := TO_JSONB(NEW);
        affected_record_id := new_record ->> TG_ARGV[0];

    ELSIF TG_OP = 'DELETE' THEN
        old_record := TO_JSONB(OLD);
        affected_record_id := old_record ->> TG_ARGV[0];
    END IF;

    INSERT INTO audit_logs (
        table_name,
        record_id,
        operation,
        old_data,
        new_data,
        changed_by
    )
    VALUES (
        TG_TABLE_NAME,
        affected_record_id,
        TG_OP,
        old_record,
        new_record,
        SESSION_USER
    );

    RETURN NULL;
END;
$$;

-- 3. Audit changes to users
CREATE TRIGGER audit_users_changes
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION record_audit_changes('user_id');

-- 4. Audit changes to subscriptions
CREATE TRIGGER audit_subscriptions_changes
AFTER INSERT OR UPDATE OR DELETE ON subscriptions
FOR EACH ROW
EXECUTE FUNCTION record_audit_changes('subscription_id');

-- 5. Audit changes to payments
CREATE TRIGGER audit_payments_changes
AFTER INSERT OR UPDATE OR DELETE ON payments
FOR EACH ROW
EXECUTE FUNCTION record_audit_changes('payment_id');

-- 6. Add indexes for audit log searches
CREATE INDEX idx_audit_logs_table_changed
ON audit_logs (table_name, changed_at);

CREATE INDEX idx_audit_logs_record
ON audit_logs (table_name, record_id);