SELECT *
FROM tihana_sales_2020;

CREATE TABLE tihana_staging
LIKE tihana_sales_2020;

SELECT *
FROM tihana_staging;

INSERT tihana_staging
SELECT *
FROM tihana_sales_2020;

UPDATE tihana_staging
SET Customer = LOWER(Customer);

SELECT Customer, TRIM(Customer)
FROM tihana_staging;

UPDATE tihana_staging
SET Customer = TRIM(Customer);

SELECT Tel_No, TRIM(Tel_No)
FROM tihana_staging;

UPDATE tihana_staging
SET Tel_No = TRIM(Tel_No);

SELECT DISTINCT state
FROM tihana_staging;

UPDATE tihana_staging
SET state = 'Perak'
WHERE state LIKE 'Perak%';

UPDATE tihana_staging
SET state = 'Selangor'
WHERE state LIKE 'Selangor%';

UPDATE tihana_staging
SET state = 'Melaka'
WHERE state LIKE 'Melaka%';

SELECT DISTINCT City
FROM tihana_staging;

SELECT City, TRIM(City)
FROM tihana_staging;

UPDATE tihana_staging
SET City = TRIM(City);

SELECT DISTINCT Date_Purchased
FROM tihana_staging;

UPDATE tihana_staging
SET Date_Purchased= '10/30/2020'
WHERE Date_Purchased LIKE '10/0/2020';

UPDATE tihana_staging
SET Date_Purchased  = STR_TO_DATE(Date_Purchased, '%m/%d/%Y');

ALTER TABLE tihana_staging
MODIFY COLUMN Date_Purchased DATE;

SELECT DISTINCT *
FROM tihana_staging;

CREATE TABLE tihana_staging2
LIKE tihana_staging;

SELECT *
FROM tihana_staging2;

INSERT tihana_staging2
SELECT *
FROM tihana_staging;

UPDATE tihana_staging2
SET State = null
WHERE State = '';

UPDATE tihana_staging2
SET City  = null
WHERE City  = '';

UPDATE tihana_staging2
SET Tel_No  = null
WHERE Tel_No  = '';

SELECT 
t1.customer,
coalesce(t1.state, t2.state) AS State,
coalesce(t1.city, t2.city) AS City,
coalesce(t1.tel_no, t2.tel_no) AS Tel_No
FROM tihana_staging2 t1
LEFT JOIN tihana_staging2 t2
ON t1.customer = t2.customer
AND t1.state IS NOT NULL
AND t1.city IS NOT NULL
AND t1.tel_no IS NOT NULL;

UPDATE tihana_staging2 t1
JOIN ( 
		SELECT customer,
			   MAX(state) AS State,
               MAX(city) AS City,
               Max(tel_no) AS Tel_No
		FROM tihana_staging2
        GROUP BY customer
	) t2 ON t1.customer =t2.customer
SET 
	t1.state = coalesce(t1.state, t2.state),
	t1.city = coalesce(t1.city, t2.city),	
    t1.tel_no = coalesce(t1.tel_no, t2.tel_no);

UPDATE tihana_staging2
SET State = 'Unknown'
WHERE State IS NULL;

UPDATE tihana_staging2
SET City  = 'Unknown'
WHERE City IS NULL;

UPDATE tihana_staging2
SET Tel_No  = 'Unknown'
WHERE Tel_No IS NULL;

UPDATE tihana_staging2
SET Tel_No  = 'Unknown'
WHERE Tel_No IS NULL;

UPDATE tihana_staging2
SET Sales = 'RM0.00'
WHERE Sales = ' RM-   ';

UPDATE tihana_staging2
SET Profit = 'RM0.00'
WHERE Profit = ' RM-   ';

UPDATE tihana_staging2
SET Sales = CAST(REPLACE(Sales,'RM','') AS DECIMAL(10,2));

ALTER TABLE tihana_staging2
MODIFY COLUMN Sales INT;

UPDATE tihana_staging2
SET Profit = CAST(REPLACE(Profit,'RM','') AS DECIMAL(10,2));

ALTER TABLE tihana_staging2
MODIFY COLUMN Profit INT;

SELECT Sales, TRIM(Sales)
FROM tihana_staging2;

UPDATE tihana_staging2
SET Sales = TRIM(Sales);

UPDATE tihana_staging2
SET Profit = TRIM(Profit);

ALTER TABLE tihana_staging2
RENAME COLUMN Tel_No
TO `Phone Number`;

ALTER TABLE tihana_staging2
DROP COLUMN `DID THEY PAY IT?`,
DROP COLUMN `DID I SHIP IT?`,
DROP COLUMN `Tracking_No`,
DROP COLUMN Week,
DROP COLUMN `Phone Number`;

ALTER TABLE tihana_staging2
RENAME COLUMN Date_Purchased
TO `Date`;

SELECT *
FROM tihana_staging2;

CREATE TABLE cleaned_tihana
LIKE tihana_staging2;

SELECT *
FROM cleaned_tihana;

INSERT cleaned_tihana
SELECT *
FROM tihana_staging2;

