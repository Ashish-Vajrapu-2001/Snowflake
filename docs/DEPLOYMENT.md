# Deployment Guide: Bronze Layer

## Prerequisites
1. Snowflake Account (Standard Edition or higher).
2. Fivetran Account with Azure SQL connectors enabled.
3. Azure SQL Source Databases with CDC enabled (for ERP/CRM).
4. Python 3.8+ installed (for API script).

## Step-by-Step Deployment

### 1. Snowflake Infrastructure
Execute the SQL scripts in the following order via Snowsight:
1. `sql/control_tables/01_create_control_schema.sql`
2. `sql/control_tables/02_create_control_tables.sql`
3. `sql/control_tables/03_populate_control_tables.sql`

### 2. Fivetran Configuration
1. Update `fivetran/connectors/*.yaml` with actual passwords.
2. Run the setup script: