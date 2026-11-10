\# DATABASE WEEK 8 – REAL-TIME ANALYTICS PLATFORM

\## DAY 5 – MONITORING VERIFICATION REPORT



\### Monitoring Tools

\- Prometheus 3.16.0

\- PostgreSQL Exporter 0.20.1

\- Grafana 13.3.0

\- PostgreSQL 18.6



\### Monitoring Verification



The PostgreSQL monitoring system was successfully connected to Prometheus and Grafana.



The following metrics were tested:



| Metric | Verified Result |

|---|---:|

| PostgreSQL health | 1 (UP) |

| Active sessions | 1–2 observed |

| Capstone database size | 26,105,535 bytes |

| Committed transactions | 22,676 |

| Rolled-back transactions | 2 |

| Cache hit ratio | 100% during the test period |



\### Dashboard Evidence



Six Grafana dashboards were created and saved:

1\. Active Sessions

2\. Cache Hit Ratio

3\. Capstone Database Size

4\. PostgreSQL Health

5\. Transaction Commits

6\. Transaction Rollbacks



Screenshot: `evidence/day5-grafana-dashboards.png`



\### Conclusion



Prometheus successfully collected PostgreSQL metrics through the PostgreSQL Exporter. Grafana successfully displayed the collected metrics.



The monitoring setup demonstrates database health monitoring, connection monitoring, storage monitoring, transaction monitoring, and cache performance monitoring.

