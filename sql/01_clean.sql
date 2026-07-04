-- I will begin cleaning data

-- Mainly ran in DBrowser for SQLite
-- This is more so for records

-- To check our tables run this
-- This helps confirm that the imported CSV has the expected columns.
PRAGMA table_info(retail_raw);

-- Count the number of rows in the raw table before cleaning.
-- This gives the starting row count before removing any rows, we should have 1,067,371
SELECT COUNT(*) AS raw_row_count
FROM retail_raw;



-- Lets create our new cleaned table
CREATE TABLE retail_clean AS
SELECT
    Invoice,
    StockCode,
    TRIM(Description) AS Description,
    CAST(Quantity AS INTEGER) AS Quantity,
    InvoiceDate,
    CAST(Price AS REAL) AS Price,
    TRIM(CAST("Customer ID" AS TEXT)) AS CustomerID,
    Country,
    CAST(Quantity AS INTEGER) * CAST(Price AS REAL) AS Revenue
FROM retail_raw
WHERE "Customer ID" IS NOT NULL
    AND TRIM(CAST("Customer ID" AS TEXT)) <> ''
    AND CAST(Quantity AS INTEGER) > 0
    AND CAST(Price AS REAL) > 0
    AND Invoice NOT LIKE 'C%'; 

-- Count how many rows are left after cleaning should be 805549
SELECT COUNT(*) AS clean_row_count
FROM retail_clean;

-- Check that the cleaning rules worked.
-- All four values should return 0.
SELECT
    SUM(CASE 
        WHEN CustomerID IS NULL OR TRIM(CustomerID) = '' 
        THEN 1 ELSE 0 
    END) AS missing_customer_id_rows,

    SUM(CASE 
        WHEN Quantity <= 0 
        THEN 1 ELSE 0 
    END) AS bad_quantity_rows,

    SUM(CASE 
        WHEN Price <= 0 
        THEN 1 ELSE 0 
    END) AS bad_price_rows,

    SUM(CASE 
        WHEN Invoice LIKE 'C%' 
        THEN 1 ELSE 0 
    END) AS cancelled_invoice_rows
FROM retail_clean;


-- Preview the cleaned table.
-- This helps confirm that the cleaned data looks correct.
SELECT *
FROM retail_clean
LIMIT 20;


-- Check that revenue was calculated correctly.
-- Revenue and check_revenue should match.
SELECT
    Quantity,
    Price,
    Revenue,
    Quantity * Price AS check_revenue
FROM retail_clean
LIMIT 20;