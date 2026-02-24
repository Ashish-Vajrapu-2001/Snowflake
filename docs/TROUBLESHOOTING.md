# Troubleshooting Guide

## 1. Fivetran Sync Failing
*   **Symptom:** Data not appearing in Bronze tables.
*   **Check:** Fivetran Dashboard Logs.
*   **Common Cause:** Source database password expired or firewall rules changed.
*   **Fix:** Update credentials in Fivetran or whitelist Fivetran IPs in Azure SQL.

## 2. Streams Not Capturing Data
*   **Symptom:** Tasks running but processing 0 records.
*   **Check:** `SHOW STREAMS;`
*   **Cause:** Stream might be stale (older than 14 days) or table was re-created (dropped/created) by Fivetran during a full re-sync.
*   **Fix:** Re-run `streams/create_bronze_streams.sql` to recreate the stream. Note: This resets the offset.

## 3. Tasks Failed
*   **Symptom:** `TASK_EXECUTION_LOG` shows 'FAILED'.
*   **Check:** `ERROR_MESSAGE` column in the log table.
*   **Common Cause:** Schema drift (new column added in source, not yet in target Silver table).
*   **Fix:** Update Silver table DDL and retry.

## 4. High Costs
*   **Symptom:** Resource Monitor alert received.
*   **Check:** `QUERY_HISTORY` for long-running tasks.
*   **Fix:** Increase Task schedule interval (e.g., 5 min -> 15 min) or resize Warehouse.