-- DATA CLEANING PROJECT: PAKISTAN E-COMMERCE DATA (PAKISTANEC)
-- Step 1: Initial Data Exploration

SELECT *
FROM pakistanec; 

-- Step 2: Create a Staging Table for Cleaning

CREATE TABLE pakistanec_staging
LIKE pakistanec;

SELECT *
FROM pakistanec_staging;

INSERT pakistanec_staging
SELECT *
FROM pakistanec;

-- Step 3: Remove Duplicates

SELECT * ,
ROW_NUMBER() OVER (
PARTITION BY item_id, status, created_at, sku, price, qty_ordered, grand_total, increment_id, category_name_1, sales_commission_code, 
discount_amount, payment_method, Working_Date, BI_Status, MV, Year, Month, `Customer Since`, `M-Y`, FY, `Customer ID`) AS row_num
FROM pakistanec;

-- Identify duplicates based on all relevant columns
With duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER (
PARTITION BY item_id, status, created_at, sku, price, qty_ordered, grand_total, increment_id, category_name_1, sales_commission_code, 
discount_amount, payment_method, Working_Date, BI_Status, MV, Year, Month, `Customer Since`, `M-Y`, FY, `Customer ID`) AS row_num
FROM pakistanec
)
-- View duplicate rows
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- No duplicates found

-- Step 4: Standardize the Data

-- Review and standardize categorical columns

SELECT DISTINCT status
FROM pakistanec_staging;

SELECT DISTINCT BI_Status
FROM pakistanec_staging;

SELECT DISTINCT payment_method
FROM pakistanec_staging;

-- Standardize Date Formats

SELECT created_at
FROM pakistanec_staging;

-- Convert created_at to DATE
UPDATE pakistanec_staging
SET created_at  = STR_TO_DATE(created_at, '%m/%d/%Y %H:%i:%s');

ALTER TABLE pakistanec_staging
MODIFY COLUMN created_at DATE;

-- Convert 'Customer Since' to DATE
UPDATE pakistanec_staging
SET created_at = DATE(created_at);

SELECT `Customer Since`
FROM pakistanec_staging;

UPDATE pakistanec_staging
SET `Customer Since`  = STR_TO_DATE(`Customer Since`, '%m/%d/%Y');

ALTER TABLE pakistanec_staging
MODIFY COLUMN `Customer Since` DATE;

-- Convert Working_Date to DATE

SELECT Working_Date
FROM pakistanec_staging;

UPDATE pakistanec_staging
SET Working_Date  = STR_TO_DATE(Working_Date, '%m/%d/%Y %H:%i:%s');

ALTER TABLE pakistanec_staging
MODIFY COLUMN Working_Date DATE;

UPDATE pakistanec_staging
SET Working_Date = DATE(Working_Date);

-- Step 5: Handle Null or Blank Values

-- Identify nulls

SELECT *
FROM pakistanec_staging
WHERE sales_commission_code IS NULL
AND category_name_1 IS NULL;

-- Clean blank or invalid values

UPDATE pakistanec_staging
SET BI_Status = null
WHERE BI_Status = '';

UPDATE pakistanec_staging
SET sales_commission_code  = null
WHERE sales_commission_code  = '\\N';

UPDATE pakistanec_staging
SET category_name_1  = null
WHERE category_name_1  = '\\N';

-- Fill missing sales_commission_code based on matching category_name_1
SELECT t1.category_name_1 ,t2.category_name_1
FROM pakistanec_staging t1
JOIN pakistanec_staging t2
	ON t1.sales_commission_code = t2.sales_commission_code
WHERE (t1.category_name_1 IS NULL )
AND t2.category_name_1 IS NOT NULL;

UPDATE pakistanec_staging t1
JOIN pakistanec_staging t2
	ON t1.category_name_1 = t2.category_name_1
SET t1.sales_commission_code = t2.sales_commission_code 
WHERE t1.sales_commission_code IS NULL 
AND t2.sales_commission_code IS NOT NULL;

SELECT *
FROM pakistanec_staging
WHERE category_name_1 IS NULL
AND sales_commission_code IS NULL;

-- Delete rows where both category_name_1 and sales_commission_code are still null
DELETE 
FROM pakistanec_staging
WHERE category_name_1 IS NULL
AND sales_commission_code IS NULL
LIMIT 500;

SELECT *
FROM pakistanec_staging;

-- Delete rows where BI_status is null
DELETE 
FROM pakistanec_staging
WHERE BI_Status IS NULL;

SELECT *
FROM pakistanec_staging;

-- Change Null to Unknown for category_name
UPDATE pakistanec_staging
SET category_name  = 'Unknown'
WHERE category_name  IS NULL;

-- Step 6: Drop Unnecessary Columns

ALTER TABLE pakistanec_staging
DROP COLUMN Year,
DROP COLUMN Month,
DROP COLUMN `M-Y`;

SELECT *
FROM pakistanec_staging;

-- Step 7: Rename Columns (for clarity and consistency)

ALTER TABLE pakistanec_staging
RENAME COLUMN category_name_1
TO category_name;

-- Step 8: Create Cleaned Final Table

CREATE TABLE pakistanec_cleaned
LIKE pakistanec_staging;

SELECT *
FROM pakistanec_cleaned;

INSERT pakistanec_cleaned
SELECT *
FROM pakistanec_staging;
