-- Cleaning Data in SQL

SELECT *
FROM samplesuperstore;

-- Remove Duplicates

-- Step 1: Create a Staging Table for data manipulation (without affecting original dataset)
CREATE TABLE samplesuperstore_staging
LIKE samplesuperstore;

SELECT *
FROM samplesuperstore_staging;

INSERT samplesuperstore_staging
SELECT *
FROM samplesuperstore;

SELECT * ,
ROW_NUMBER() OVER (
PARTITION BY `Ship Mode`, Segment, Country, City, State, `Postal Code`, 
Region, Category, `Sub-Category`, Sales, Quantity, Discount, Profit) AS row_num
FROM samplesuperstore_staging;

-- Step 2: Identify duplicates using ROW_NUMBER() function and CTE
With duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER (
PARTITION BY `Ship Mode`, Segment, Country, City, State, `Postal Code`, 
Region, Category, `Sub-Category`, Sales, Quantity, Discount, Profit) AS row_num
FROM samplesuperstore_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Step 3: Delete rows where duplicates are found (where row_num > 1)
WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER (
PARTITION BY `Ship Mode`, Segment, Country, City, State, `Postal Code`, 
Region, Category, `Sub-Category`, Sales, Quantity, Discount, Profit) AS row_num
FROM samplesuperstore_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `samplesuperstore_staging2` (
  `Ship Mode` text,
  `Segment` text,
  `Country` text,
  `City` text,
  `State` text,
  `Postal Code` int DEFAULT NULL,
  `Region` text,
  `Category` text,
  `Sub-Category` text,
  `Sales` double DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Discount` double DEFAULT NULL,
  `Profit` double DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM samplesuperstore_staging2
WHERE row_num > 1;

INSERT INTO samplesuperstore_staging2
SELECT * ,
ROW_NUMBER() OVER (
PARTITION BY `Ship Mode`, Segment, Country, City, State, `Postal Code`, 
Region, Category, `Sub-Category`, Sales, Quantity, Discount, Profit) AS row_num
FROM samplesuperstore_staging;

DELETE 
FROM samplesuperstore_staging2
WHERE row_num > 1;

SELECT * 
FROM samplesuperstore_staging2;

SELECT COUNT(*) FROM samplesuperstore_staging2;

SELECT * 
FROM samplesuperstore_staging2;

-- Step 4: Standardize text data by trimming trailing commas and periods

UPDATE samplesuperstore_staging2
SET
  `Ship Mode` = TRIM(TRAILING '.' FROM TRIM(TRAILING ',' FROM TRIM(`Ship Mode`))),
  `Segment` = TRIM(TRAILING '.' FROM TRIM(TRAILING ',' FROM TRIM(`Segment`))),
  `Country` = TRIM(TRAILING '.' FROM TRIM(TRAILING ',' FROM TRIM(`Country`))),
  `City` = TRIM(TRAILING '.' FROM TRIM(TRAILING ',' FROM TRIM(`City`))),
  `State` = TRIM(TRAILING '.' FROM TRIM(TRAILING ',' FROM TRIM(`State`))),
  `Region` = TRIM(TRAILING '.' FROM TRIM(TRAILING ',' FROM TRIM(`Region`))),
  `Category` = TRIM(TRAILING '.' FROM TRIM(TRAILING ',' FROM TRIM(`Category`))),
  `Sub-Category` = TRIM(TRAILING '.' FROM TRIM(TRAILING ',' FROM TRIM(`Sub-Category`)));

SELECT * 
FROM samplesuperstore_staging2;

-- Step 5: Check for NULL values in key columns
-- (no issues found in this dataset)
SELECT
  COUNT(*) AS total_rows,
  
  SUM(CASE WHEN `Ship Mode` IS NULL OR TRIM(`Ship Mode`) = '' THEN 1 ELSE 0 END) AS null_ship_mode,
  SUM(CASE WHEN `Segment` IS NULL OR TRIM(`Segment`) = '' THEN 1 ELSE 0 END) AS null_segment,
  SUM(CASE WHEN `Country` IS NULL OR TRIM(`Country`) = '' THEN 1 ELSE 0 END) AS null_country,
  SUM(CASE WHEN `City` IS NULL OR TRIM(`City`) = '' THEN 1 ELSE 0 END) AS null_city,
  SUM(CASE WHEN `State` IS NULL OR TRIM(`State`) = '' THEN 1 ELSE 0 END) AS null_state,
  SUM(CASE WHEN `Postal Code` IS NULL THEN 1 ELSE 0 END) AS null_postal_code,
  SUM(CASE WHEN `Region` IS NULL OR TRIM(`Region`) = '' THEN 1 ELSE 0 END) AS null_region,
  SUM(CASE WHEN `Category` IS NULL OR TRIM(`Category`) = '' THEN 1 ELSE 0 END) AS null_category,
  SUM(CASE WHEN `Sub-Category` IS NULL OR TRIM(`Sub-Category`) = '' THEN 1 ELSE 0 END) AS null_subcategory,
  SUM(CASE WHEN `Sales` IS NULL THEN 1 ELSE 0 END) AS null_sales,
  SUM(CASE WHEN `Quantity` IS NULL THEN 1 ELSE 0 END) AS null_quantity,
  SUM(CASE WHEN `Discount` IS NULL THEN 1 ELSE 0 END) AS null_discount,
  SUM(CASE WHEN `Profit` IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM samplesuperstore_staging2;

-- Step 6: Remove the extra 'row_num' column after cleaning

ALTER TABLE samplesuperstore_staging2
DROP COLUMN row_num;

SELECT * 
FROM samplesuperstore_staging2;

-- Step 7: Add a primary key (auto-increment) column for easier reference
-- Primary Column
ALTER TABLE samplesuperstore_staging2
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;

SELECT * 
FROM samplesuperstore_staging2;

-- Step 8: Rename the cleaned table to reflect its cleaned status
RENAME TABLE samplesuperstore_staging2 
TO samplesuperstore_cleaned;

-- Step 9: Create a backup table in case a rollback is needed later
CREATE TABLE samplesuperstore_backup AS
SELECT * FROM samplesuperstore_cleaned;

-- Final Check: Confirm the cleaned table is ready for use
SELECT * 
FROM samplesuperstore_cleaned;




