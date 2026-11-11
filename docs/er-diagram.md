# Database Week 8 - Entity Relationship Diagram

## Real-Time Analytics Platform

The diagram shows the main entities and their relationships.

```mermaid
erDiagram
    TENANTS ||--o{ USERS : has
    TENANTS ||--o{ EVENTS : generates
    TENANTS ||--o{ SUBSCRIPTIONS : owns
    USERS ||--o{ SESSIONS : starts
    USERS ||--o{ EVENTS : performs
    SESSIONS ||--o{ EVENTS : contains
    EVENT_TYPES ||--o{ EVENTS : classifies
    PLANS ||--o{ SUBSCRIPTIONS : defines
    SUBSCRIPTIONS ||--o{ PAYMENTS : receives

    TENANTS {
        int tenant_id PK
        varchar tenant_name
    }

    USERS {
        int user_id PK
        int tenant_id FK
    }

    SESSIONS {
        int session_id PK
        int user_id FK
    }

    EVENT_TYPES {
        int event_type_id PK
        varchar event_name
    }

    EVENTS {
        bigint event_id
        int tenant_id FK
        int user_id FK
        int session_id FK
        int event_type_id FK
        timestamptz occurred_at
        text redis_stream_id
    }

    PLANS {
        int plan_id PK
        varchar plan_name
    }

    SUBSCRIPTIONS {
        int subscription_id PK
        int tenant_id FK
        int plan_id FK
    }

    PAYMENTS {
        int payment_id PK
        int subscription_id FK
    }
```

## Explanation

- TENANTS: Stores customer organizations.
- USERS: Stores users belonging to tenants.
- SESSIONS: Records user sessions.
- EVENT_TYPES: Defines event categories.
- EVENTS: Stores application activity and timestamps.
- PLANS: Stores subscription plans.
- SUBSCRIPTIONS: Connects tenants to plans.
- PAYMENTS: Records subscription payments.

The events table uses PostgreSQL range partitioning on occurred_at.
