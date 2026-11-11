# Database Week 8 - Formal Requirements Brief

## 1. Project Title
Real-Time Analytics Platform

## 2. Project Overview
The project develops a multi-tenant analytics platform using PostgreSQL, Redis Streams, Python, Prometheus, and Grafana. It is designed to collect, store, process, and analyze high-volume application events.

## 3. Project Objectives
- Build a reliable PostgreSQL database for application events.
- Support multiple tenants with appropriate data isolation.
- Ingest events through Redis Streams and Python.
- Improve analytical query performance through indexing and partitioning.
- Provide monitoring and database performance visibility.
- Demonstrate database backup and restoration.

## 4. Functional Requirements
1. Store tenant, user, session, event, subscription, plan, and payment records.
2. Partition event data by event timestamp.
3. Support tenant-level access control through Row-Level Security.
4. Record important database changes using audit triggers.
5. Receive events through Redis Streams.
6. Process events and insert them into PostgreSQL without duplicate ingestion.
7. Provide five analytical reports:
   - Daily active users.
   - Conversion funnel.
   - Cohort retention.
   - Monthly subscription revenue.
   - Popular events.
8. Support database backup and restoration.
9. Monitor PostgreSQL using Prometheus and Grafana.

## 5. Non-Functional Requirements
- Performance: Use appropriate indexes and query optimization.
- Scalability: Support growing event volumes through partitioning.
- Security: Apply Row-Level Security and audit logging.
- Reliability: Use Redis consumer groups and controlled message acknowledgments.
- Recoverability: Provide backup and restore procedures.
- Observability: Monitor database health and performance metrics.

## 6. Technology Stack
- PostgreSQL 18.6
- Flyway 13.12.1
- Python 3.14.3
- Memurai (Redis-compatible service)
- Prometheus 3.16.0
- PostgreSQL Exporter 0.20.1
- Grafana 13.3.0

## 7. Expected Deliverables
- Database requirements and ER diagram.
- SQL schema and migration files.
- Multi-tenant security policies and audit triggers.
- Redis Streams integration scripts.
- Analytical SQL queries.
- Performance benchmark results and execution plans.
- Partitioning and retention documentation.
- Backup and restore scripts and verification evidence.
- Monitoring documentation and dashboard screenshots.

## 8. Implementation Scope and Limitations
- PostgreSQL native declarative partitioning is used.
- Memurai provides Redis-compatible functionality on Windows.
- TimescaleDB compression is not implemented.
- A streaming replica is not implemented.
- Retention and archival procedures are documented rather than fully automated.
- Tenant isolation depends on trusted application-side tenant context.

## 9. Acceptance Criteria
The project is considered complete when:
- Database migrations execute successfully.
- Required tables, indexes, and partitions exist.
- Tenant security policies and audit triggers are verified.
- Redis events can be ingested into PostgreSQL.
- Analytical queries return results.
- Performance benchmarks are captured.
- Backup and restoration are tested.
- PostgreSQL monitoring is operational.
- Project documentation and evidence are included.

## 10. Conclusion
This project demonstrates database architecture, multi-tenant security, event ingestion, analytical processing, performance optimization, backup and recovery, and monitoring.
