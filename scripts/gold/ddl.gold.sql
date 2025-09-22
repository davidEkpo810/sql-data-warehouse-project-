/*
================================================================================
DDL Script: Create Gold Views
================================================================================
Script Purpose:
    This Script creates views for the Gold layer in the data warehouse
    The Gold layer represents the final dimension and facts tables (star schema)

    Each view perfroms transformations and combines data from the silver layer
    to producew a clean, enriched and business-ready dataset.

Usage:
    - These views can be directly queried for analytics and reporting.
================================================================================
*/
- - ============================================================================
-- create dimension: gold_dim_customer
- - ============================================================================
CREATE OR REPLACE VIEW gold_dim_customer AS
SELECT
	ROW_NUMBER () OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
     ct.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE 
    WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
    ELSE cs.gen
    END AS gender,
    cs.bdate AS birth_date,
    ci.cst_create_date
FROM silver_crm_cust_info AS ci
LEFT JOIN silver_erp_cust_az12 AS cs
ON ci.cst_key = cs.civ
LEFT JOIN silver_erp_loc_a101 AS ct
ON ci.cst_key = ct.cid;
;

- - ============================================================================
-- create dimension: gold_dim_product
- - ============================================================================
CREATE OR REPLACE VIEW gold_dim_product AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY prd_start_dt, prd_key) AS product_key,
	pd.prd_id AS product_id,
    pd.prd_key AS product_number,
	pd.prd_nm AS product_name,
    pd.cat_id AS category_id,
    ps.cat AS category,
    ps.subcat AS subcategory,
    ps.maintenance ,
    pd.prd_cost AS product_cost,
    pd.prd_line AS product_line,
    pd.prd_start_dt AS start_date
FROM silver_crm_prd_info AS pd
LEFT JOIN silver_px_cat_giv2 As ps
ON pd.cat_id = ps.id 
WHERE prd_end_dt IS NULL -- Filter out all historical data
;

- - ============================================================================
-- create dimension: gold_fact_sales
- - ============================================================================
CREATE OR REPLACE VIEW gold_fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
    pr.product_key,
    dc.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver_crm_sales_details sd
LEFT JOIN gold_dim_product pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold_dim_customer dc
ON sd.sls_cust_id = dc.customer_id
;
