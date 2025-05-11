-- Exploratory Data Analysis (EDA)
-- Purpose: To explore the cleaned ECommerce dataset and extract meaningful business insights.

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

-- Orders per year
SELECT 
  YEAR(created_at) AS year, 
  COUNT(*) AS total_orders
FROM pakistanec_cleaned
GROUP BY year
ORDER BY year;

-- Monthly order trend
SELECT 
  DATE_FORMAT(created_at, '%Y-%m') AS month, 
  COUNT(*) AS total_orders,
  SUM(grand_total) AS total_revenue
FROM pakistanec_cleaned
GROUP BY month
ORDER BY month;

-- Payment Method Insights
-- Count and percentage of each payment method
SELECT 
  payment_method,
  COUNT(*) AS total_orders,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM pakistanec_cleaned), 2) AS percentage
FROM pakistanec_cleaned
GROUP BY payment_method
ORDER BY total_orders DESC;

-- Top Products and Categories
-- Top 10 most sold items by quantity
SELECT 
  item_id,
  SUM(qty_ordered) AS total_qty
FROM pakistanec_cleaned
GROUP BY item_id
ORDER BY total_qty DESC
LIMIT 10;

-- Top categories by total revenue
SELECT 
  category_name,
  SUM(grand_total) AS revenue
FROM pakistanec_cleaned
GROUP BY category_name
ORDER BY revenue DESC
LIMIT 10;

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

-- Sales Commission Analysis
-- Total commission by sales code
SELECT 
  sales_commission_code,
  COUNT(*) AS order_count,
  SUM(grand_total) AS total_sales
FROM pakistanec_cleaned
GROUP BY sales_commission_code
ORDER BY total_sales DESC
LIMIT 10;

-- Final null value check
SELECT 
  SUM(CASE WHEN category_name IS NULL THEN 1 ELSE 0 END) AS null_category,
  SUM(CASE WHEN sales_commission_code IS NULL THEN 1 ELSE 0 END) AS null_sales_commission,
  SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS null_payment
FROM pakistanec_cleaned;
