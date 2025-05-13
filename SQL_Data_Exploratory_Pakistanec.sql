-- Exploratory Data Analysis (EDA)

-- Basic Info
-- Total number of rows
SELECT COUNT(*) AS total_rows 
FROM pakistanec_cleaned;

-- Preview first 10 records
SELECT * 
FROM pakistanec_cleaned 
LIMIT 10;

-- Column list and data types
SHOW COLUMNS FROM pakistanec_cleaned;

-- Numeric Summary
-- Summary stats for price, quantity, and total
SELECT 
  MIN(price) AS min_price,
  MAX(price) AS max_price,
  AVG(price) AS avg_price,
  MIN(qty_ordered) AS min_qty,
  MAX(qty_ordered) AS max_qty,
  AVG(qty_ordered) AS avg_qty,
  MIN(grand_total) AS min_total,
  MAX(grand_total) AS max_total,
  AVG(grand_total) AS avg_total
FROM pakistanec_cleaned;

-- Time-based analysis 
-- Date range of orders
SELECT 
  MIN(created_at) AS first_order_date,
  MAX(created_at) AS last_order_date
FROM pakistanec_cleaned;

-- Monthly order trend
SELECT 
  DATE_FORMAT(created_at, '%Y-%m') AS month, 
  COUNT(*) AS total_orders,
  SUM(grand_total) AS total_revenue
FROM pakistanec_cleaned
GROUP BY month
ORDER BY month;

-- Customer Analysis
-- Number of unique customers
SELECT COUNT(DISTINCT `Customer ID`) AS unique_customers 
FROM pakistanec_cleaned;

-- New vs returning customers (based on first purchase)
SELECT 
  CASE 
    WHEN `Customer Since` = created_at THEN 'New'
    ELSE 'Returning'
  END AS customer_type,
  COUNT(*) AS total_orders
FROM pakistanec_cleaned
GROUP BY customer_type;
-- Sales and Status by month
SELECT 
  MONTH(Working_Date) AS Month,
  Status,
  SUM(grand_total) AS Total_Revenue
FROM pakistanec_cleaned
GROUP BY Month, Status
ORDER BY Month;

-- Sales and Status by Category
SELECT 
  category_name AS Category,
  BI_Status,
  SUM(grand_total) AS Total_Revenue
FROM pakistanec_cleaned
GROUP BY category_name, BI_Status
ORDER BY Total_Revenue DESC;

-- Sales and Status Total Amount
SELECT 
  Status,
  SUM(grand_total) AS Total_Amount
FROM pakistanec_cleaned
GROUP BY Status;

-- Monthly Revenue Trend
SELECT 
  DATE_FORMAT(Working_Date, '%Y-%m') AS Month_Year,
  SUM(grand_total) AS Monthly_Revenue
FROM pakistanec_cleaned
WHERE BI_Status = 'NET'
GROUP BY Month_Year
ORDER BY Month_Year;

-- Quantity By Payment Method
SELECT 
  payment_method,
  SUM(qty_ordered) AS Total_Quantity
FROM pakistanec_cleaned
GROUP BY payment_method
ORDER BY Total_Quantity DESC;

-- Quantity by Category
SELECT 
  category_name AS Category,
  SUM(qty_ordered) AS Total_Quantity
FROM pakistanec_cleaned
GROUP BY category_name
ORDER BY Total_Quantity DESC;

-- Reveneue by sales commisson code
SELECT 
  sales_commission_code,
  SUM(grand_total) AS Total_Revenue
FROM pakistanec_cleaned
GROUP BY sales_commission_code
ORDER BY Total_Revenue DESC;

-- SKU by sales
SELECT 
  sku,
  SUM(grand_total) AS Total_Revenue
FROM pakistanec_cleaned
GROUP BY sku
ORDER BY Total_Revenue DESC;

-- Final null value check
SELECT 
  SUM(CASE WHEN category_name IS NULL THEN 1 ELSE 0 END) AS null_category,
  SUM(CASE WHEN sales_commission_code IS NULL THEN 1 ELSE 0 END) AS null_sales_commission,
  SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS null_payment
FROM pakistanec_cleaned;
