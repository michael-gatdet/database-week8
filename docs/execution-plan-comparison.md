# Execution Plan and Performance Comparison

## 1. Purpose

This document summarizes the execution-plan and performance tests for the Week 8 Real-Time Analytics Platform.

The tests compare the normal analytical query runs with a controlled planner comparison that avoids index-based scan methods. The purpose is to observe how PostgreSQL executes the queries under the two configurations.

## 2. Benchmark Results

The benchmark dataset contained approximately 50,000 events.

| Analytical query | Normal benchmark (ms) | Planner comparison (ms) |
|---|---:|---:|
| Daily active users | 158.841 | 171.824 |
| Conversion funnel | 127.222 | 182.091 |
| Cohort retention | 75.219 | 79.569 |
| Monthly subscription revenue | 0.497 | 0.431 |
| Popular events | 140.475 | 202.685 |

Execution times are in milliseconds. Results are from individual local test runs and may vary with system load, cache state, and database conditions.

## 3. Execution Plan Observations

The normal benchmark evidence contains PostgreSQL execution-plan details, including:

- Index Scan operations.
- Sequential Scan operations.
- Parallel Sequential Scan operations.
- Planning Time.
- Execution Time.

The planner comparison evidence shows Sequential Scan and Parallel Sequential Scan operations.

PostgreSQL may choose different scan methods depending on query conditions, available indexes, table size, and its cost estimates. Sequential scans are not automatically bad; they can be appropriate when a query needs a large portion of a table.

## 4. Performance Interpretation

The daily active users query took 158.841 ms in the normal benchmark and 171.824 ms in the planner comparison.

The conversion funnel query took 127.222 ms and 182.091 ms respectively. The cohort retention query also took slightly longer in the planner comparison.

The monthly subscription revenue query was very fast in both runs. Its small difference should not be treated as proof that indexes reduce performance.

The popular events query took 140.475 ms in the normal benchmark and 202.685 ms in the planner comparison.

Overall, the results show that scan strategy can affect analytical query execution time. However, one local test run is not enough to establish a universal performance improvement.

## 5. Evidence Files

The detailed PostgreSQL execution plans and timings are available in:

- `evidence/day4-five-query-benchmarks.txt` — normal benchmark execution plans and timings.
- `evidence/day4-five-query-no-index-comparison.txt` — controlled planner comparison execution plans and timings.
- `evidence/day4-performance-benchmark.txt` — benchmark summary.
- `evidence/day4-benchmark-data-verification.txt` — benchmark data verification.

## 6. Test Limitation

The comparison was performed by changing PostgreSQL planner scan settings. The indexes were not physically removed from the database. Therefore, this report describes a planner comparison, not a test after deleting database indexes.

Execution times are specific to the local test environment and dataset. Repeated runs under controlled conditions would provide stronger performance conclusions.

## 7. Conclusion

The project includes recorded execution plans and performance measurements for five analytical queries. The evidence demonstrates how PostgreSQL uses different scan methods and provides a basis for evaluating query performance on the event dataset.
