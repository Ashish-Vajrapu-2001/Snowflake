# Snowflake Modern Data Stack - Bronze Layer

## Overview
This project implements the Bronze (Raw) layer of the Myntra CLV Analytics Platform. It uses Fivetran for managed ingestion from Azure SQL sources and Snowflake Streams/Tasks for Change Data Capture (CDC) processing.

## Architecture
*   **Sources:** Azure SQL (ERP, CRM, Marketing)
*   **Ingestion:** Fivetran (Log-based CDC)
*   **Storage:** Snowflake `BRONZE_DB`
*   **CDC:** Snowflake Standard Streams
*   **Orchestration:** Snowflake Tasks + Stored Procedures

## Directory Structure
*   `sql/`: Snowflake DDL and Stored Procedures.
*   `fivetran/`: Connector configurations.
*   `streams/`: CDC Stream definitions.
*   `tasks/`: Orchestration tasks.
*   `dbt/`: dbt project configuration (optional transformation layer).
*   `monitoring/`: Health and cost monitoring scripts.
*   `governance/`: RBAC and Masking policies.

## Quick Start
See `docs/DEPLOYMENT.md` for detailed installation instructions.