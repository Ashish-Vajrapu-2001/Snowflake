-------------------------------------------------------------------------------
-- OBJECTIVE: Cost Control and Resource Monitoring
-- EXECUTION: Run as ACCOUNTADMIN
-------------------------------------------------------------------------------

USE ROLE ACCOUNTADMIN;

-- Create Monitor for Bronze Layer
CREATE RESOURCE MONITOR IF NOT EXISTS BRONZE_MONITOR WITH
    CREDIT_QUOTA = 500
    FREQUENCY = MONTHLY
    START_TIMESTAMP = IMMEDIATELY
    NOTIFY_USERS = ('DATA_ENGINEER_ADMIN')
    TRIGGERS
        ON 75 PERCENT DO NOTIFY
        ON 90 PERCENT DO NOTIFY
        ON 100 PERCENT DO SUSPEND;

-- Assign to Warehouses
ALTER WAREHOUSE TRANSFORM_WH SET RESOURCE_MONITOR = BRONZE_MONITOR;
-- If using a dedicated loader warehouse
-- ALTER WAREHOUSE LOADER_WH SET RESOURCE_MONITOR = BRONZE_MONITOR;