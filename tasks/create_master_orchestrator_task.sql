-------------------------------------------------------------------------------
-- OBJECTIVE: Master Task for Health Checks (Optional Orchestrator)
-------------------------------------------------------------------------------

CREATE OR REPLACE TASK BRONZE_DB.CONTROL.TSK_MASTER_HEALTH_CHECK
    WAREHOUSE = TRANSFORM_WH
    SCHEDULE = '60 MINUTE'
AS
BEGIN
    -- Check for stale streams
    INSERT INTO BRONZE_DB.CONTROL.TASK_EXECUTION_LOG (TASK_NAME, EXECUTION_STATUS, ERROR_MESSAGE, START_TIME)
    SELECT 
        'STALE_STREAM_CHECK', 
        'WARNING', 
        'Stream ' || STREAM_NAME || ' has not been processed in 24 hours',
        CURRENT_TIMESTAMP()
    FROM BRONZE_DB.CONTROL.STREAM_METADATA sm
    JOIN BRONZE_DB.CONTROL.TABLE_METADATA tm ON sm.SOURCE_TABLE = tm.BRONZE_TABLE_NAME
    WHERE tm.LAST_SYNC_TIMESTAMP < DATEADD(HOUR, -24, CURRENT_TIMESTAMP());
END;

ALTER TASK BRONZE_DB.CONTROL.TSK_MASTER_HEALTH_CHECK RESUME;