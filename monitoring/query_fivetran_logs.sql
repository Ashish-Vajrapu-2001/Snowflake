-------------------------------------------------------------------------------
-- OBJECTIVE: Monitor Fivetran Ingestion Health
-- NOTE: Requires FIVETRAN_LOG database (created by Fivetran Log Connector)
-------------------------------------------------------------------------------

-- 1. Check Connector Status
SELECT 
    connector_name, 
    service, 
    sync_frequency, 
    setup_state, 
    sync_state
FROM FIVETRAN_LOG.ACCOUNT.CONNECTOR_STATUS
WHERE connector_name IN ('azure_sql_erp_connector', 'azure_sql_crm_connector', 'azure_sql_marketing_connector');

-- 2. Check Recent Sync Failures
SELECT 
    connector_name,
    start_time,
    end_time,
    status,
    message_data
FROM FIVETRAN_LOG.ACCOUNT.LOG
WHERE event = 'sync_end' 
  AND status = 'FAILURE'
  AND time_stamp > DATEADD(DAY, -7, CURRENT_TIMESTAMP())
ORDER BY time_stamp DESC;

-- 3. Check Volume Loaded
SELECT 
    destination_table,
    SUM(rows_modified) as total_rows
FROM FIVETRAN_LOG.ACCOUNT.LOG
WHERE event = 'load_summary'
  AND time_stamp > DATEADD(DAY, -1, CURRENT_TIMESTAMP())
GROUP BY destination_table;