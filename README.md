# Database Week 8 - Real-Time Analytics Platform

## Project Overview
A real-time analytics platform built with PostgreSQL, Memurai, Python, Prometheus, and Grafana.

## Main Features
- PostgreSQL event storage with monthly partitioning.
- BRIN and B-tree indexes.
- Flyway migrations V1-V7.
- Row-level security and audit triggers.
- Materialized analytics views.
- Redis Streams event ingestion using Python.
- Duplicate event protection using redis_stream_id and occurred_at.
- Five analytical queries and performance benchmarks.
- Automated PostgreSQL backup and restore verification.
- Prometheus and Grafana monitoring.

## Technologies
- PostgreSQL 18.6
- Flyway 13.12.1
- Python 3.14.3
- Memurai
- Prometheus 3.16.0
- PostgreSQL Exporter 0.20.1
- Grafana 13.3.0

## Project Documentation
- [Requirements Brief](docs/requirements-brief.md)
- [Entity Relationship Diagram](docs/er-diagram.md)
- [Execution Plan Comparison](docs/execution-plan-comparison.md)
- [Benchmark Documentation](docs/benchmarks.md)
- [Backup and Restore Guide](docs/backup-restore.md)
- [Redis Architecture](docs/day3-redis-architecture.md)
- [Monitoring Guide](docs/day5-monitoring.md)
- [Partitioning and Retention Policy](docs/partitioning-retention-policy.md)

## Project Structure
- docs/ - Project documentation and analytical queries.
- evidence/ - Benchmark results, execution plans, and verification records.
- scripts/ - Python integration and PostgreSQL backup scripts.
- sql/ - Database migration files V1-V7.
- backups/ - Local database backup files (not uploaded to GitHub).

## Important Database Migration
Migration V7 adds redis_stream_id to the events table and creates a unique index on (redis_stream_id, occurred_at) to support duplicate event protection.

## Backup Automation
Run this command from the project folder:

    .\scripts\backup_database.ps1

The script creates a timestamped PostgreSQL backup in the local backups folder.

## Verification
The project includes migration verification, Redis integration tests, analytical query benchmarks, execution plan comparisons, partition pruning tests, backup and restore verification, and monitoring evidence.

## Important Notes
- PostgreSQL declarative partitioning is used.
- Memurai provides Redis-compatible functionality on Windows.
- A streaming replica and TimescaleDB compression are not implemented.
- Row-level security requires trusted application-side tenant context.
- Benchmark execution times may vary depending on the machine and database conditions.

## Conclusion
The project demonstrates database design, event ingestion, analytics, performance testing, backup and recovery, and database monitoring.
