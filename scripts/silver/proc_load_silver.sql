/*
=================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
=================================================================================
Script Purpose:
    This stored procedure perfrorms the ETL (Extract, Transform, Load) process to
    populate the 'silver' Table from the 'bronze' schema.
  Actions Performed:
    - Truncates silver tables.
    - Inserts transformed and cleansed data from Bronze into silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.
=================================================================================
*/

TRUNCATE TABLE silver_crm_cust_info;
INSERT INTO silver_crm_cust_info (cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
	SELECT
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		ELSE 'n/a'
		END AS cst_marital_status,
		CASE
		WHEN UPPER(TRIM(cst_gndr)) = 'M'THEN 'Male'
		WHEN UPPER(TRIM(cst_gndr))  = 'F'THEN 'Female'
		ELSE 'n/a'
		END AS cst_gndr,
		cst_create_date
	FROM
	(SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date) AS flag_last
	FROM bronze_crm_cust_info) i WHERE i.flag_last = 1 AND cst_id IS NOT NULL
;

TRUNCATE TABLE silver_crm_prd_info;
INSERT INTO silver_crm_prd_info (prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
SELECT
	prd_id,
    REPLACE(SUBSTRING(prd_key,1,5), '-','_') AS cat_id, -- Extract category ID
    SUBSTRING(prd_key,7, LENGTH(prd_key)) AS prd_key, -- Extract product key
    prd_nm,
    IFNULL(prd_cost,0) AS prd_cost,
    CASE
		WHEN UPPER(prd_line) = 'M' THEN 'Montain'
        WHEN UPPER(prd_line) = 'R' THEN 'Road'
        WHEN UPPER(prd_line) = 'S' THEN 'other Sales'
        WHEN UPPER(prd_line) = 'T' THEN 'Touring'
        ELSE 'n/a'
        END AS prd_line, -- Map product line codes to descriptive values
    prd_start_dt,
		LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) 
		AS prd_end_dt -- Calculate end date from prd_start_dt
FROM bronze_crm_prd_info
;

TRUNCATE TABLE silver_crm_sales_details;
INSERT INTO silver_crm_sales_details (sls_ord_num,sls_prd_key,
sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
SELECT
	sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    CASE WHEN
		sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
        END AS sls_sales, -- Recalculate sales if original value is missing or incorrect
	sls_quantity,
    CASE WHEN
    sls_price IS NULL OR sls_price <= 0 OR sls_price != ABS(sls_sales) / NULLIF(sls_quantity,0)
    THEN ABS(sls_sales) / NULLIF(sls_quantity,0)
    ELSE sls_price
    END AS sls_price -- Derive price is original value is missing or invalid
FROM bronze_crm_sales_details
;


TRUNCATE TABLE silver_erp_cust_az12;
INSERT INTO silver_erp_cust_az12 (civ,bdate,gen)
SELECT
	CASE
	WHEN civ LIKE 'NAS%' THEN SUBSTRING(civ,4,LENGTH(civ)) -- Remove 'NAS' prefix if present
    ELSE civ
    END AS civ,
    CASE
    WHEN bdate > CURRENT_DATE THEN NULL -- set future birthdate to NULL
    ELSE bdate
    END AS bdate,
    CASE
    WHEN UPPER(TRIM(gen)) LIKE '%F%' OR UPPER(TRIM(gen)) LIKE '%FEMALE%' THEN 'Female'
    WHEN UPPER(TRIM(gen)) LIKE '%M%' OR UPPER(TRIM(gen)) LIKE '%MALE%' THEN 'Male'
    ELSE 'n/a'
    END AS gen -- Normalizegender values and handle unkown cases
FROM bronze_erp_cust_az12    
;

TRUNCATE TABLE silver_erp_loc_a101;
INSERT INTO silver_erp_loc_a101 (cid,cntry)
SELECT
    REPLACE(cid,'-','') AS cid, -- Replacing '-' to match with other tables
	CASE
    WHEN UPPER(TRIM(cntry)) LIKE '%AUSTRALIA%' THEN 'Australia'
    WHEN UPPER(TRIM(cntry)) LIKE '%US%' OR UPPER(TRIM(cntry)) LIKE '%UNITED STATES%' THEN 'United States'
	WHEN UPPER(TRIM(cntry)) LIKE '%CANADA%' THEN 'Canada'
	WHEN UPPER(TRIM(cntry)) LIKE  '%DE%' THEN 'Denmark'
	WHEN UPPER(TRIM(cntry)) LIKE  '%FRANCE%' THEN 'France'
	WHEN UPPER(TRIM(cntry)) LIKE  '%UNITED KINGDOM%' THEN 'United Kingdom'
    ELSE 'n/a'
    END AS cntry
FROM bronze_erp_loc_a101
;


TRUNCATE TABLE silver_px_cat_giv2;
INSERT INTO silver_px_cat_giv2 (id,cat,subcat,maintenance)
SELECT
	id,
    cat,
    subcat,
    CASE
	  WHEN UPPER(TRIM(maintenance)) LIKE '%YES%' THEN 'Yes'
	  ELSE maintenance
	  END AS maintenance
FROM bronze_px_cat_giv2
;
