# DATABASE SECURITY AND BACKUP PROCEDURES

## 1. Database security

The Real-Time Analytics Platform uses PostgreSQL security features.

### User and role management
- The project uses a dedicated capstone_app database role.
- The role has limited permissions.
- The role is not a superuser.
- The role does not have permission to bypass row-level security.

### Row-Level Security (RLS)
- RLS is enabled on tenants, users, sessions, events, subscriptions and payments.
- Tenant policies restrict access to records belonging to the configured tenant.
- The application server must securely establish the tenant context.

### Audit logging
- An audit_logs table records selected INSERT, UPDATE and DELETE operations.
- Database triggers record changes to users, subscriptions and payments.
- Audit records include the operation, table, old data, new data and timestamp.

### Index and data protection
- Database access is controlled through PostgreSQL roles and permissions.
- Application credentials should be stored securely.
- Database connections should use appropriate authentication and encryption in production.

## 2. Backup strategy

The project uses PostgreSQL custom-format logical backups.

Command used:

pg_dump -Fc -U postgres -h localhost -p 5432 -d capstone -f backup.dump

The custom format supports restoration using pg_restore.

## 3. Backup verification

The backup archive was inspected using:

pg_restore -l backup.dump

The archive contained database tables, indexes, functions, triggers, partitions, security policies and materialized view data.

## 4. Restore testing

The backup was restored into a separate database named capstone_restore_test.

Verification results:
- 14 tables found.
- 50,016 events restored.
- 7 users restored.
- 23 materialized view rows restored.
- 4 event partitions restored.

The original capstone database remained unchanged.

## 5. Recommended production practices

- Schedule regular automated backups.
- Store backup copies separately from the database server.
- Encrypt backups containing sensitive information.
- Test restoration regularly.
- Restrict access to database credentials.
- Monitor database activity and failed login attempts.
- Define a retention schedule for old backups.

## 6. Conclusion

The project demonstrates PostgreSQL role management, Row-Level Security, audit logging, logical backups and successful database restoration.

The tested backup and restore process provides a foundation for database recovery.
