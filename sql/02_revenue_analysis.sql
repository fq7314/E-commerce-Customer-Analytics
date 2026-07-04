-- I will begin the revenue analysis portion
-- Run these queries in DB Browser for SQLite using retail_project.db.
-- These queries use the cleaned table: retail_clean.

/* Five questions I will answer:
Total revenue
Revenue by month
Top 10 products by revenue
One-time buyers
Repeat buyers */


-- Question 1: What is the total revenue?
-- This shows how much money came in from all valid purchases.

SELECT
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM retail_clean;

-- Result was 17743429.18 in total revenue

-- Question 2: How much revenue was made each month?
-- helps us find is the total revenue for each month in the dataset, allows us to see trends over time.

SELECT
    SUBSTR(InvoiceDate, 1, 7) AS invoice_month,
    ROUND(SUM(Revenue), 2) AS monthly_revenue
FROM retail_clean
GROUP BY invoice_month
ORDER BY invoice_month;

-- Results:
-- Seems to show that 2010-11 has the highest revenue, trend seems to lean more towards sep to november

-- Question 3: Which products made the most revenue?
-- This shows which items are the drivers for revenue

SELECT
    Description,
    ROUND(SUM(Revenue), 2) AS product_revenue,
    SUM(Quantity) AS total_units_sold,
    COUNT(DISTINCT Invoice) AS number_of_orders
FROM retail_clean
WHERE Description IS NOT NULL
    AND TRIM(Description) <> ''
GROUP BY Description
ORDER BY product_revenue DESC
LIMIT 10;

-- Results: REGENCY CAKESTAND 3 TIER made most revenue, 286,486.30 in revenue.

-- Question 4: How many customers bought only once?
-- This shows how many customers did not return after their first purchase.

WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT Invoice) AS invoice_count,
        ROUND(SUM(Revenue), 2) AS total_spend
    FROM retail_clean
    GROUP BY CustomerID
)

SELECT
    COUNT(*) AS one_time_customers,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM customer_orders),
        2
    ) AS percent_of_all_customers,
    ROUND(AVG(total_spend), 2) AS avg_one_time_customer_spend
FROM customer_orders
WHERE invoice_count = 1;

-- Results:One-time buyers made up 27.61% of all customers, 1,623 one-time buyers, 350.08 average spend

-- Question 5: we want to make a comparison to one time buyers and return so I will break into three parts for better analysis
-- Part 1: How do repeat buyers compare to one-time buyers in average spend, total revenue, and percentage of total revenue?
-- Part 2: What products do one-time buyers spend the most on, how much?
-- Part 3: What products do repeat buyers spend the most on, how much?

-- Part 1:
-- This version is with rounding
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT Invoice) AS invoice_count,
        ROUND(SUM(Revenue), 2) AS total_spend
    FROM retail_clean
    GROUP BY CustomerID
)

SELECT
    CASE
        WHEN invoice_count = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END AS customer_type,
    COUNT(*) AS number_of_customers,
    ROUND(AVG(total_spend), 2) AS avg_customer_spend,
    ROUND(SUM(total_spend), 2) AS total_revenue,
    100.0 * ROUND(SUM(total_spend), 2) / (SELECT SUM(Revenue) FROM retail_clean) AS percent_of_total_revenue
FROM customer_orders
GROUP BY customer_type
ORDER BY total_revenue DESC;
-- This is no rounding
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT Invoice) AS invoice_count,
        SUM(Revenue) AS total_spend
    FROM retail_clean
    GROUP BY CustomerID
)

SELECT
    CASE
        WHEN invoice_count = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END AS customer_type,
    COUNT(*) AS number_of_customers,
    AVG(total_spend) AS avg_customer_spend,
    SUM(total_spend) AS total_revenue,
    100.0 * SUM(total_spend) / (SELECT SUM(Revenue) FROM retail_clean) AS percent_of_total_revenue
FROM customer_orders
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Results: Repeat buyers: about 96.8% of total revenue, One-time buyers: about 3.2% of total revenue


-- Part 2:
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT Invoice) AS invoice_count
    FROM retail_clean
    GROUP BY CustomerID
)

SELECT
    r.Description,
    ROUND(SUM(r.Revenue), 2) AS product_revenue,
    SUM(r.Quantity) AS total_units_sold,
    COUNT(DISTINCT r.Invoice) AS number_of_orders
FROM retail_clean r
JOIN customer_orders c
    ON r.CustomerID = c.CustomerID
WHERE c.invoice_count = 1
    AND r.Description NOT IN ('Manual', 'POSTAGE')
GROUP BY r.Description
ORDER BY product_revenue DESC
LIMIT 10;

-- Part 3:
WITH customer_orders AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT Invoice) AS invoice_count
    FROM retail_clean
    GROUP BY CustomerID
)

SELECT
    r.Description,
    ROUND(SUM(r.Revenue), 2) AS product_revenue,
    SUM(r.Quantity) AS total_units_sold,
    COUNT(DISTINCT r.Invoice) AS number_of_orders
FROM retail_clean r
JOIN customer_orders c
    ON r.CustomerID = c.CustomerID
WHERE c.invoice_count >= 2
    AND r.Description NOT IN ('Manual', 'POSTAGE')
GROUP BY r.Description
ORDER BY product_revenue DESC
LIMIT 10;
-- Results for part 2-3: REGENCY CAKESTAND 3 TIER top product, Group: One-Time Buyers revenue: 7,791.00
-- group: Repeat Buyers revenue: 278,695.30
