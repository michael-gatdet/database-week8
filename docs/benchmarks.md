# DAY 4 - ANALYTICAL QUERY PERFORMANCE BENCHMARKS

## 1. Overview

Five analytical queries were tested using PostgreSQL EXPLAIN ANALYZE and BUFFERS.

The database contained 50,016 events during testing.

## 2. Normal benchmark results

| Query | Execution Time |
|---|---:|
| Daily active users | 158.841 ms |
| Conversion funnel | 127.222 ms |
| Cohort retention | 75.219 ms |
| Monthly subscription revenue | 0.497 ms |
| Popular events | 140.475 ms |

## 3. No-index-style benchmark results

| Query | Execution Time |
|---|---:|
| Daily active users | 171.824 ms |
| Conversion funnel | 182.091 ms |
| Cohort retention | 79.569 ms |
| Monthly subscription revenue | 0.431 ms |
| Popular events | 202.685 ms |

## 4. Performance analysis

The comparison showed that daily active users, conversion funnel, cohort retention and popular events took longer in the no-index-style test.

Monthly subscription revenue had almost the same execution time because the payments table contained only two records.

PostgreSQL used sequential scans for the large events partition when index scan methods were disabled. The normal query plans used indexes where the planner considered them useful.

## 5. Important benchmark limitation

This was a controlled planner comparison. Indexes were not physically removed. PostgreSQL index scan methods were temporarily disabled for the second test and reset after execution.

The measurements may vary depending on caching, system activity and query planning.

## 6. Conclusion

The benchmark demonstrated how PostgreSQL query plans and indexes can affect analytical query performance.

The database successfully executed all five analytical queries against 50,016 events. The results provide a performance baseline for future optimization.
