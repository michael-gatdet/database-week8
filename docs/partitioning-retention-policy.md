# PARTITIONING AND DATA RETENTION POLICY

## 1. Partitioning strategy

The events table uses PostgreSQL native declarative range partitioning based on occurred_at.

The project includes:
- events_2026_11: November 2026
- events_2026_12: December 2026
- events_2027_01: January 2027
- events_default: events outside the defined monthly ranges

## 2. Benefits

- Improves management of large event datasets.
- Allows PostgreSQL to scan only relevant partitions.
- Supports efficient date-based queries.
- Makes older data easier to archive or remove.

## 3. Partition pruning verification

A query for November 10, 2026 scanned only events_2026_11.

Execution time: 14.688 ms.

This confirms that partition pruning is working.

## 4. Proposed retention policy

- Keep recent event data in active monthly partitions.
- Review partitions older than 12 months.
- Export older partitions to secure archival storage before removal.
- Verify archived data before dropping any partition.
- Keep backup copies according to the organization's backup policy.

## 5. Safe partition maintenance

PostgreSQL supports detaching and dropping old partitions.

Before removing a partition:
1. Confirm that it is outside the retention period.
2. Create and verify an archive or backup.
3. Confirm that the data is no longer needed by reports.
4. Obtain approval.
5. Detach or drop the partition according to the maintenance plan.

## 6. Compression note

This project uses native PostgreSQL partitioning. TimescaleDB compression has not been implemented. Older partitions can instead be archived using PostgreSQL backup and export tools.

## 7. Conclusion

Monthly partitioning, partition pruning and a documented retention policy support efficient management of high-volume event data.
