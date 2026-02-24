-------------------------------------------------------------------------------
-- OBJECTIVE: Create Database and Control Schema
-- EXECUTION: Run as ACCOUNTADMIN or SYSADMIN
-------------------------------------------------------------------------------

-- Create the Bronze Database
CREATE DATABASE IF NOT EXISTS BRONZE_DB
    COMMENT = 'Raw landing zone for Fivetran ingestion';

-- Create the Control Schema for Metadata
CREATE SCHEMA IF NOT EXISTS BRONZE_DB.CONTROL
    COMMENT = 'Metadata and orchestration control tables';

-- Create Data Schemas (as defined in LLD)
CREATE SCHEMA IF NOT EXISTS BRONZE_DB.BRONZE_ERP;
CREATE SCHEMA IF NOT EXISTS BRONZE_DB.BRONZE_CRM;
CREATE SCHEMA IF NOT EXISTS BRONZE_DB.BRONZE_MARKETING;