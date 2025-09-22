# Naming Conventions
This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse.

# Table of Contents
- General Principles
- Table Naming Conventions
    - Bronze Rules
    - Silver Rules
    - Gold Rules
- Column Naming Conventions
    - Surrogate Keys
    - Technical Columns
- Stored Procedure

# General Principles
- *Naming Conventions*: Use `snake_case`, with lowercase letters and underscores (`_`) to separate words.
- *Language*: Use English for all names.
- *Avoid Reserved Words*: Do not use SQL reserved words as object names.

# Table Naming Conventions
*Bronze Rules*
- All names must start with the source system name, and table names must match their original names without renaming.
- Format: `<sourcesystem>_<entity>`
- Example: `crm_customer_info` → Customer information from the CRM system.

*Silver Rules*
- All names must start with the source system name, and table names must match their original names without renaming.
- Format: `<sourcesystem>_<entity>`
- Example: `crm_customer_info` → Customer information from the CRM system.

*Gold Rules*
- All names must use meaningful, business-aligned names for tables, starting with the category prefix.
- Format: `<category>_<entity>`
- Examples:
    - `dim_customers` → Dimension table for customer data.
    - `fact_sales` → Fact table containing sales transactions.

# Glossary of Category Patterns
| Pattern | Meaning | Example(s) |
| --- | --- | --- |
| dim_ | Dimension table | dim_customer, dim_product |
| fact_ | Fact table | fact_sales |
| report_ | Report table | report_customers, report_sales_monthly |

# Column Naming Conventions
*Surrogate Keys*
- All primary keys in dimension tables must use the suffix `_key`.
- Format: `<table_name>_key`
- Example: `customer_key` → Surrogate key in the `dim_customers` table.

*Technical Columns*
- All technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.
- Format: `dwh_<column_name>`
- Example: `dwh_load_date` → System-generated column used to store the date when the record was loaded.

# Stored Procedure
- All stored procedures used for loading data must follow the naming pattern: `load_<layer>`.
- Format: `load_<layer>`
- Examples:
    - `load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `load_silver` → Stored procedure for loading data into the Silver layer.

