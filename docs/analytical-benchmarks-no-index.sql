SET enable_indexscan = off;
SET enable_indexonlyscan = off;
SET enable_bitmapscan = off;
\timing on

-- QUERY 1: DAILY ACTIVE USERS
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    e.tenant_id,
    t.tenant_name,
    (e.occurred_at AT TIME ZONE 'UTC')::DATE AS activity_date,
    COUNT(DISTINCT e.user_id) AS daily_active_users
FROM events e
JOIN tenants t ON t.tenant_id = e.tenant_id
GROUP BY
    e.tenant_id,
    t.tenant_name,
    (e.occurred_at AT TIME ZONE 'UTC')::DATE
ORDER BY activity_date, e.tenant_id;


-- QUERY 2: CONVERSION FUNNEL
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    e.tenant_id,
    t.tenant_name,
    COUNT(DISTINCT e.user_id)
        FILTER (WHERE et.event_name = 'page_view') AS page_view_users,
    COUNT(DISTINCT e.user_id)
        FILTER (WHERE et.event_name = 'signup') AS signup_users,
    COUNT(DISTINCT e.user_id)
        FILTER (WHERE et.event_name = 'add_to_cart') AS add_to_cart_users,
    COUNT(DISTINCT e.user_id)
        FILTER (WHERE et.event_name = 'purchase') AS purchase_users
FROM events e
JOIN tenants t ON t.tenant_id = e.tenant_id
JOIN event_types et ON et.event_type_id = e.event_type_id
GROUP BY e.tenant_id, t.tenant_name
ORDER BY e.tenant_id;


-- QUERY 3: COHORT RETENTION
EXPLAIN (ANALYZE, BUFFERS)
WITH user_cohorts AS (
    SELECT
        tenant_id,
        user_id,
        DATE_TRUNC('month', MIN(occurred_at)) AS cohort_month
    FROM events
    GROUP BY tenant_id, user_id
),
monthly_activity AS (
    SELECT DISTINCT
        tenant_id,
        user_id,
        DATE_TRUNC('month', occurred_at) AS activity_month
    FROM events
),
cohort_sizes AS (
    SELECT
        tenant_id,
        cohort_month,
        COUNT(*) AS cohort_size
    FROM user_cohorts
    GROUP BY tenant_id, cohort_month
),
retention AS (
    SELECT
        c.tenant_id,
        c.cohort_month,
        a.activity_month,
        COUNT(DISTINCT a.user_id) AS active_users
    FROM user_cohorts c
    JOIN monthly_activity a
        ON a.tenant_id = c.tenant_id
        AND a.user_id = c.user_id
    WHERE a.activity_month >= c.cohort_month
    GROUP BY
        c.tenant_id,
        c.cohort_month,
        a.activity_month
)
SELECT
    r.tenant_id,
    t.tenant_name,
    r.cohort_month::DATE AS cohort_month,
    r.activity_month::DATE AS activity_month,
    (
        (EXTRACT(YEAR FROM r.activity_month) -
         EXTRACT(YEAR FROM r.cohort_month)) * 12
        +
        (EXTRACT(MONTH FROM r.activity_month) -
         EXTRACT(MONTH FROM r.cohort_month))
    )::INTEGER AS months_since_first_activity,
    s.cohort_size,
    r.active_users,
    ROUND(
        100.0 * r.active_users / NULLIF(s.cohort_size, 0),
        2
    ) AS retention_percentage
FROM retention r
JOIN cohort_sizes s
    ON s.tenant_id = r.tenant_id
    AND s.cohort_month = r.cohort_month
JOIN tenants t ON t.tenant_id = r.tenant_id
ORDER BY r.tenant_id, r.cohort_month, r.activity_month;


-- QUERY 4: MONTHLY SUBSCRIPTION REVENUE
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    t.tenant_name,
    p.plan_name,
    pay.currency,
    DATE_TRUNC('month', pay.paid_at) AS revenue_month,
    COUNT(pay.payment_id) AS total_payments,
    SUM(pay.amount) AS total_revenue
FROM payments pay
JOIN subscriptions s ON s.subscription_id = pay.subscription_id
JOIN tenants t ON t.tenant_id = s.tenant_id
JOIN plans p ON p.plan_id = s.plan_id
GROUP BY
    t.tenant_name,
    p.plan_name,
    pay.currency,
    DATE_TRUNC('month', pay.paid_at)
ORDER BY revenue_month, t.tenant_name, p.plan_name;


-- QUERY 5: POPULAR EVENTS
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    e.tenant_id,
    t.tenant_name,
    et.event_name,
    COUNT(*) AS total_events,
    COUNT(DISTINCT e.user_id) AS unique_users,
    COUNT(DISTINCT e.session_id) AS unique_sessions
FROM events e
JOIN tenants t ON t.tenant_id = e.tenant_id
JOIN event_types et ON et.event_type_id = e.event_type_id
GROUP BY
    e.tenant_id,
    t.tenant_name,
    et.event_name
ORDER BY e.tenant_id, total_events DESC;
RESET enable_indexscan;
RESET enable_indexonlyscan;
RESET enable_bitmapscan;
