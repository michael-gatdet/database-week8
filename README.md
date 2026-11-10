# Database Week 8 - Real-Time Analytics Platform

## Project Overview
This project implements a real-time analytics platform using PostgreSQL, Redis-compatible Memurai, Python, Prometheus, and Grafana.

## Main Features
- PostgreSQL event storage with monthly partitioning.
- Database indexes, including BRIN.
- Flyway database migrations (V1-V7).
- Row-level security and audit triggers.
- Materialized analytics views.
- Redis Streams event ingestion using Python.
- Five analytical queries and performance benchmarks.
- Database backup and restore verification.
- Prometheus and Grafana monitoring.

## Technologies
- PostgreSQL 18.6
- Flyway 13.12.1
- Python 3.14.3
- Memurai (Redis-compatible)
- Prometheus 3.16.0
- PostgreSQL Exporter 0.20.1
- Grafana 13.3.0

## Project Structure
- backups/ - Database backup files
- docs/ - Project documentation and analytical queries
- evidence/ - Verification records and screenshots
- scripts/ - Python Redis integration scripts
- sql/ - Database migration files V1-V7

## Verification
The project includes migration verification, Redis integration tests, analytical query benchmarks, partition pruning tests, backup and restore verification, and monitoring evidence.

## Important Notes
- PostgreSQL declarative partitioning is used.
- Memurai provides Redis-compatible functionality on Windows.
- A streaming replica and TimescaleDB compression are not implemented.
- Row-level security requires trusted application-side tenant context.

## Conclusion
The project demonstrates database design, event ingestion, analytics, performance testing, backup and recovery, and database monitoring.
