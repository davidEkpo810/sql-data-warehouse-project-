/*
========================================================================================
Stored Procedure : Load Bronze layer (Source -> Bronze)
========================================================================================
Key Features:
    Data Cleaning: 
        The script trims and nullifies empty strings for columns.
    Date Validation: 
        The script validates the `cst_create_date` column to ensure it conforms to the 
        `YYYY-MM-DD` format. Invalid dates are set to `NULL`.
    CSV Import: 
        The script uses MySQL's `LOAD DATA INFILE` statement to import data from the 
        CSV file, handling fields terminated by commas, optionally enclosed by double 
        quotes, and lines terminated by newline characters.
========================================================================================
Script Purpose:
    This table creates tables in the 'Bronze' schema, Truncating before loading data 
    prevent duplicate values.
========================================================================================
*/

TRUNCATE TABLE bronze_crm_cust_info;

LOAD DATA INFILE '/private/tmp/cust_info.csv'
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, @cst_create_date)
SET 
    cst_id = NULLIF(TRIM(@cst_id), ''),
    cst_create_date = CASE 
        WHEN TRIM(@cst_create_date) = '' THEN NULL
        WHEN TRIM(@cst_create_date) = ' ' THEN NULL
        WHEN TRIM(@cst_create_date) REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN TRIM(@cst_create_date)
        ELSE NULL
    END;

TRUNCATE TABLE bronze_crm_prd_info;

LOAD DATA INFILE '/private/tmp/prd_info.csv'
INTO TABLE bronze_crm_prd_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@prd_id, @prd_key, @prd_nm, @prd_cost, @prd_line, @prd_start_dt, @prd_end_dt)
SET
  prd_id       = NULLIF(TRIM(@prd_id), ''),
  prd_key      = NULLIF(TRIM(@prd_key), ''),
  prd_nm       = NULLIF(TRIM(@prd_nm), ''),
  prd_cost     = NULLIF(TRIM(@prd_cost), ''),  
  prd_line     = NULLIF(TRIM(@prd_line), ''),
  prd_start_dt = NULLIF(TRIM(@prd_start_dt), ''),
  prd_end_dt   = NULLIF(TRIM(@prd_end_dt), '');

TRUNCATE TABLE bronze_crm_sales_details;

LOAD DATA INFILE '/private/tmp/sales_details.csv'
INTO TABLE bronze_crm_sales_details
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@sls_ord_num, @sls_prd_key, @sls_cust_id, 
 @sls_order_dt, @sls_ship_dt, @sls_due_dt,
 @sls_sales, @sls_quantity, @sls_price)
SET
 sls_ord_num  = NULLIF(TRIM(@sls_ord_num), ''),
 sls_prd_key  = NULLIF(TRIM(@sls_prd_key), ''),
 sls_cust_id  = NULLIF(TRIM(@sls_cust_id), ''),
 sls_order_dt = CASE 
                  WHEN TRIM(@sls_order_dt) REGEXP '^[0-9]{8}$' 
                  THEN STR_TO_DATE(TRIM(@sls_order_dt), '%Y%m%d') 
                  ELSE NULL 
                END,
 sls_ship_dt  = CASE 
                  WHEN TRIM(@sls_ship_dt) REGEXP '^[0-9]{8}$' 
                  THEN STR_TO_DATE(TRIM(@sls_ship_dt), '%Y%m%d') 
                  ELSE NULL 
                END,
 sls_due_dt   = CASE 
                  WHEN TRIM(@sls_due_dt) REGEXP '^[0-9]{8}$' 
                  THEN STR_TO_DATE(TRIM(@sls_due_dt), '%Y%m%d') 
                  ELSE NULL 
                END,
 sls_sales    = NULLIF(TRIM(@sls_sales), ''),
 sls_quantity = NULLIF(TRIM(@sls_quantity), ''),
 sls_price    = NULLIF(TRIM(REPLACE(REPLACE(REPLACE(@sls_price, ' ', ''), '\r', ''), '\t', '')), '');

TRUNCATE TABLE bronze_erp_cust_az12;

LOAD DATA INFILE '/private/tmp/CUST_AZ12.csv'
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@civ, @bdate, @gen)
SET
 civ =  IFNULL(TRIM(@civ), ''),
 bdate = IFNULL(TRIM(@bdate), ''),
 gen = IFNULL(TRIM(@gen), '');


LOAD DATA INFILE '/private/tmp/LOC_A101.csv'
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid, @cntry)
SET
 cid = IFNULL(TRIM(@cid), ''),
 cntry = IFNULL(TRIM(@cntry), '');
   
TRUNCATE TABLE bronze_px_cat_giv2;

 LOAD DATA INFILE '/private/tmp/PX_CAT_G1V2.csv'
 INTO TABLE bronze_px_cat_giv2
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 ROWS
 (@id, @cat, @subcat, @maintenance)
 SET
  id = IFNULL(TRIM(@id), ''),
  cat = IFNULL(TRIM(@cat), ''),
  subcat = IFNULL(TRIM(@subcat), ''),
  maintenance = IFNULL(TRIM(@maintenance), '')
 
 
 
 LOAD DATA INFILE
 INTO TABLE
 FIELDS TERMINATED BY
 OPTIONALLY ENCLOSED BY
 LINES TERMINATED BY
 IGNORE 1 ROWS 
