-- ============================================================
-- 1. DATABASE & TABLE INSPECTION
-- ============================================================

USE banking_data;

-- Inspect table structures
DESCRIBE bank_data;
DESCRIBE customer_data;
DESCRIBE transaction_data;

-- Check row counts
SELECT COUNT(*) AS row_count
FROM customer_data;

SELECT COUNT(*) AS row_count
FROM transaction_data;

SELECT COUNT(*) AS row_count
FROM bank_data;

-- ============================================================
-- 2. DATA QUALITY CHECKS
-- ============================================================

-- 2.1 Duplicate Checks

-- Check for duplicate records in bank_data
SELECT
    Branch_ID,
    City,
    Region,
    Firm_Revenue,
    Expenses,
    Profit_Margin,
    COUNT(*) AS duplicate_count
FROM bank_data
GROUP BY
    Branch_ID,
    City,
    Region,
    Firm_Revenue,
    Expenses,
    Profit_Margin
HAVING COUNT(*) > 1;


-- Check for duplicate records in customer_data
SELECT
    Customer_ID,
    Age,
    Customer_Type,
    City,
    Region,
    Bank_Name,
    Branch_ID,
    COUNT(*) AS duplicate_count
FROM customer_data
GROUP BY
    Customer_ID,
    Age,
    Customer_Type,
    City,
    Region,
    Bank_Name,
    Branch_ID
HAVING COUNT(*) > 1;


-- Check for duplicate records in transaction_data
SELECT
    Transaction_ID,
    Customer_ID,
    Account_Type,
    Total_Balance,
    Transaction_Amount,
    Investment_Amount,
    Investment_Type,
    Transaction_Date,
    COUNT(*) AS duplicate_count
FROM transaction_data
GROUP BY
    Transaction_ID,
    Customer_ID,
    Account_Type,
    Total_Balance,
    Transaction_Amount,
    Investment_Amount,
    Investment_Type,
    Transaction_Date
HAVING COUNT(*) > 1;

-- 2.2 NULL Value Checks

-- Check for NULL values in customer_data
SELECT
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS customer_id_missing,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS age_missing,
    SUM(CASE WHEN Customer_Type IS NULL THEN 1 ELSE 0 END) AS customer_type_missing,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS city_missing,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS region_missing,
    SUM(CASE WHEN Bank_Name IS NULL THEN 1 ELSE 0 END) AS bank_name_missing,
    SUM(CASE WHEN Branch_ID IS NULL THEN 1 ELSE 0 END) AS branch_id_missing
FROM customer_data;


-- Check for NULL values in transaction_data
SELECT
    SUM(CASE WHEN Transaction_ID IS NULL THEN 1 ELSE 0 END) AS transaction_id_missing,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS customer_id_missing,
    SUM(CASE WHEN Account_Type IS NULL THEN 1 ELSE 0 END) AS account_type_missing,
    SUM(CASE WHEN Total_Balance IS NULL THEN 1 ELSE 0 END) AS total_balance_missing,
    SUM(CASE WHEN Transaction_Amount IS NULL THEN 1 ELSE 0 END) AS transaction_amount_missing,
    SUM(CASE WHEN Investment_Amount IS NULL THEN 1 ELSE 0 END) AS investment_amount_missing,
    SUM(CASE WHEN Investment_Type IS NULL THEN 1 ELSE 0 END) AS investment_type_missing,
    SUM(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END) AS transaction_date_missing
FROM transaction_data;


-- Check for NULL values in bank_data
SELECT
    SUM(CASE WHEN Branch_ID IS NULL THEN 1 ELSE 0 END) AS branch_id_missing,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS city_missing,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS region_missing,
    SUM(CASE WHEN Firm_Revenue IS NULL THEN 1 ELSE 0 END) AS firm_revenue_missing,
    SUM(CASE WHEN Expenses IS NULL THEN 1 ELSE 0 END) AS expenses_missing,
    SUM(CASE WHEN Profit_Margin IS NULL THEN 1 ELSE 0 END) AS profit_margin_missing
FROM bank_data;


-- Check for blank/empty text values in customer_data
SELECT
    SUM(CASE WHEN Customer_Type = '' THEN 1 ELSE 0 END) AS customer_type_blank,
    SUM(CASE WHEN City = '' THEN 1 ELSE 0 END) AS city_blank,
    SUM(CASE WHEN Region = '' THEN 1 ELSE 0 END) AS region_blank,
    SUM(CASE WHEN Bank_Name = '' THEN 1 ELSE 0 END) AS bank_name_blank
FROM customer_data;


-- Check for whitespace-only values in customer_data
SELECT
    COUNT(*) AS customer_type_whitespace
FROM customer_data
WHERE TRIM(Customer_Type) = '';


SELECT
    COUNT(*) AS city_whitespace
FROM customer_data
WHERE TRIM(City) = '';


-- Check for blank/empty text values in transaction_data
SELECT
    SUM(CASE WHEN Account_Type = '' THEN 1 ELSE 0 END) AS account_type_blank,
    SUM(CASE WHEN Investment_Type = '' THEN 1 ELSE 0 END) AS investment_type_blank
FROM transaction_data;


-- Check for whitespace-only values in bank_data
SELECT
    COUNT(*) AS city_whitespace
FROM bank_data
WHERE TRIM(City) = '';


SELECT
    COUNT(*) AS region_whitespace
FROM bank_data
WHERE TRIM(Region) = '';

-- 2.3 Value Range & Data Type Validation

-- Validate customer age range
SELECT
    MIN(Age) AS min_age,
    MAX(Age) AS max_age
FROM customer_data;


-- Validate transaction numeric ranges
SELECT
    MIN(Total_Balance) AS min_balance,
    MAX(Total_Balance) AS max_balance,
    MIN(Transaction_Amount) AS min_transaction,
    MAX(Transaction_Amount) AS max_transaction,
    MIN(Investment_Amount) AS min_investment,
    MAX(Investment_Amount) AS max_investment
FROM transaction_data;


-- Validate transaction date range
SELECT
    MIN(Transaction_Date) AS earliest_transaction_date,
    MAX(Transaction_Date) AS latest_transaction_date,
    COUNT(DISTINCT Transaction_Date) AS unique_transaction_dates
FROM transaction_data;


-- Validate bank financial value ranges
SELECT
    MIN(Firm_Revenue) AS min_revenue,
    MAX(Firm_Revenue) AS max_revenue,
    MIN(Expenses) AS min_expenses,
    MAX(Expenses) AS max_expenses,
    MIN(Profit_Margin) AS min_profit_margin,
    MAX(Profit_Margin) AS max_profit_margin
FROM bank_data;

-- 2.4 Categorical Value Validation

-- Validate customer categories
SELECT
    Customer_Type,
    COUNT(*) AS customer_count
FROM customer_data
GROUP BY Customer_Type
ORDER BY customer_count DESC;


-- Validate customer regions
SELECT
    Region,
    COUNT(*) AS customer_count
FROM customer_data
GROUP BY Region
ORDER BY customer_count DESC;


-- Validate bank names
SELECT
    Bank_Name,
    COUNT(*) AS customer_count
FROM customer_data
GROUP BY Bank_Name
ORDER BY customer_count DESC;


-- Validate account types
SELECT
    Account_Type,
    COUNT(*) AS transaction_count
FROM transaction_data
GROUP BY Account_Type
ORDER BY transaction_count DESC;


-- Validate investment types
SELECT
    Investment_Type,
    COUNT(*) AS transaction_count
FROM transaction_data
GROUP BY Investment_Type
ORDER BY transaction_count DESC;

-- 2.5 Financial Consistency Check

-- Compare the stored profit margin with the calculated margin
SELECT
    Branch_ID,
    Firm_Revenue,
    Expenses,
    Profit_Margin AS stored_profit_margin,
    ROUND(
        ((Firm_Revenue - Expenses) / Firm_Revenue) * 100,
        2
    ) AS calculated_profit_margin
FROM bank_data
LIMIT 10;


-- Identify records where the stored and calculated margins differ
SELECT
    COUNT(*) AS inconsistent_rows
FROM bank_data
WHERE ABS(
    Profit_Margin -
    (((Firm_Revenue - Expenses) / Firm_Revenue) * 100)
) > 0.01;

-- ============================================================
-- 3. DATA CLEANING & TRANSFORMATION
-- ============================================================

-- 3.1 Clean Customer Type

-- Replace blank Customer_Type values with 'Unknown'
SET SQL_SAFE_UPDATES = 0;

UPDATE customer_data
SET Customer_Type = 'Unknown'
WHERE TRIM(Customer_Type) = '';

SET SQL_SAFE_UPDATES = 1;


-- Verify the cleaned Customer_Type values
SELECT
    Customer_Type,
    COUNT(*) AS customer_count
FROM customer_data
GROUP BY Customer_Type
ORDER BY customer_count DESC;

-- 3.2 Clean City

-- Replace blank City values with 'Unknown'
SET SQL_SAFE_UPDATES = 0;

UPDATE customer_data
SET City = 'Unknown'
WHERE TRIM(City) = '';

SET SQL_SAFE_UPDATES = 1;


-- Verify the cleaned City values
SELECT
    City,
    COUNT(*) AS customer_count
FROM customer_data
GROUP BY City
ORDER BY customer_count DESC;

-- 3.3 Standardize Transaction Amount Data Type

-- Convert Transaction_Amount to DECIMAL for consistent numeric precision
ALTER TABLE transaction_data
MODIFY Transaction_Amount DECIMAL(10,2);


-- Verify the updated data type
DESCRIBE transaction_data;

-- 3.4 Create Calculated Profit Margin

-- Add a calculated profit margin column
ALTER TABLE bank_data
ADD COLUMN Calculated_Profit_Margin DECIMAL(10,2);


-- Calculate profit margin using revenue and expenses
SET SQL_SAFE_UPDATES = 0;

UPDATE bank_data
SET Calculated_Profit_Margin =
    ((Firm_Revenue - Expenses) / Firm_Revenue) * 100;

SET SQL_SAFE_UPDATES = 1;


-- Verify the calculated profit margin
SELECT
    Branch_ID,
    Firm_Revenue,
    Expenses,
    Calculated_Profit_Margin
FROM bank_data
LIMIT 10;

-- ============================================================
-- 4. RELATIONSHIP VALIDATION
-- ============================================================

-- 4.1 Validate Customer_ID uniqueness

SELECT
    Customer_ID,
    COUNT(*) AS customer_count
FROM customer_data
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- 4.2 Validate Transaction-to-Customer Relationship

-- Identify transactions with unmatched Customer_ID
SELECT
    t.Customer_ID,
    COUNT(*) AS transaction_count
FROM transaction_data t
LEFT JOIN customer_data c
    ON t.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL
GROUP BY t.Customer_ID
ORDER BY transaction_count DESC;

-- 4.3 Validate Branch_ID uniqueness

SELECT
    Branch_ID,
    COUNT(*) AS branch_count
FROM bank_data
GROUP BY Branch_ID
HAVING COUNT(*) > 1;

-- 4.4 Validate Customer-to-Branch Relationship

-- Identify customers with unmatched Branch_ID
SELECT
    c.Branch_ID,
    COUNT(*) AS customer_count
FROM customer_data c
LEFT JOIN bank_data b
    ON c.Branch_ID = b.Branch_ID
WHERE b.Branch_ID IS NULL
GROUP BY c.Branch_ID
ORDER BY customer_count DESC;
