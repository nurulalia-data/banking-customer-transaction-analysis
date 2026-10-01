-- ============================================================
-- 1. CUSTOMER & ACCOUNT ANALYSIS
-- ============================================================

-- 1.1 Customer Distribution by Customer Type
-- How many customers are there in each customer type?

SELECT
    Customer_Type,
    COUNT(*) AS customer_count
FROM customer_data
GROUP BY Customer_Type
ORDER BY customer_count DESC;


-- 1.2 Customer Distribution by Region
-- Which region has the highest number of customers?

SELECT
    Region,
    COUNT(*) AS customer_count
FROM customer_data
GROUP BY Region
ORDER BY customer_count DESC;

-- 1.3 Transaction Count by Account Type
-- Which account type has the most transactions?

SELECT
    Account_Type,
    COUNT(*) AS transaction_count
FROM transaction_data
GROUP BY Account_Type
ORDER BY transaction_count DESC;


-- 1.4 Transaction Value by Account Type
-- Which account type generates the highest total transaction amount?

SELECT
    Account_Type,
    SUM(Transaction_Amount) AS total_transaction_amount
FROM transaction_data
GROUP BY Account_Type
ORDER BY total_transaction_amount DESC;


-- 1.5 Average Transaction Amount by Account Type
-- What is the average transaction amount for each account type?

SELECT
    Account_Type,
    AVG(Transaction_Amount) AS avg_transaction_amount
FROM transaction_data
GROUP BY Account_Type
ORDER BY avg_transaction_amount DESC;


-- 1.6 Transaction Value by Customer Type
-- How much total transaction value comes from each customer type?

SELECT
    c.Customer_Type,
    SUM(t.Transaction_Amount) AS total_transaction_value
FROM transaction_data t
LEFT JOIN customer_data c
    ON t.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Type
ORDER BY total_transaction_value DESC;

-- ============================================================
-- 2. INVESTMENT ANALYSIS
-- ============================================================

-- 2.1 Total Investment by Investment Type
-- Which investment type has the highest total investment amount?

SELECT
    Investment_Type,
    SUM(Investment_Amount) AS total_investment_amount
FROM transaction_data
GROUP BY Investment_Type
ORDER BY total_investment_amount DESC;


-- 2.2 Average Investment Amount by Investment Type
-- Which investment type has the highest average investment amount per transaction?

SELECT
    Investment_Type,
    AVG(Investment_Amount) AS avg_investment_amount
FROM transaction_data
GROUP BY Investment_Type
ORDER BY avg_investment_amount DESC;

-- 2.3 Investment Activity by Investment Type
-- Which investment type has the highest number of transactions?

SELECT
    Investment_Type,
    COUNT(*) AS transaction_count
FROM transaction_data
GROUP BY Investment_Type
ORDER BY transaction_count DESC;

-- ============================================================
-- 3. BRANCH PERFORMANCE ANALYSIS
-- ============================================================

-- 3.1 Regional Revenue
-- Which region generates the highest total firm revenue?

SELECT
    Region,
    SUM(Firm_Revenue) AS total_firm_revenue
FROM bank_data
GROUP BY Region
ORDER BY total_firm_revenue DESC;


-- 3.2 Regional Expenses
-- Which region has the highest total expenses?

SELECT
    Region,
    SUM(Expenses) AS total_expenses
FROM bank_data
GROUP BY Region
ORDER BY total_expenses DESC;


-- 3.3 Regional Profitability
-- Which region has the highest average profit margin?

SELECT
    Region,
    AVG(Calculated_Profit_Margin) AS avg_profit_margin
FROM bank_data
GROUP BY Region
ORDER BY avg_profit_margin DESC;


-- 3.4 Top-Performing Branches
-- Which 10 branches have the highest calculated profit margin?

SELECT
    Branch_ID,
    Calculated_Profit_Margin
FROM bank_data
ORDER BY Calculated_Profit_Margin DESC
LIMIT 10;


-- ============================================================
-- 4. ADVANCED SQL ANALYSIS
-- ============================================================

-- 4.1 Branch Performance Classification
-- How can branches be classified based on profit margin?

SELECT
    Branch_ID,
    Calculated_Profit_Margin,
    CASE
        WHEN Calculated_Profit_Margin >= 20 THEN 'High'
        WHEN Calculated_Profit_Margin >= 10 THEN 'Moderate'
        ELSE 'Low'
    END AS performance_category
FROM bank_data
ORDER BY Calculated_Profit_Margin DESC;


-- 4.2 Performance Category Summary
-- How many branches fall into each performance category?

SELECT
    CASE
        WHEN Calculated_Profit_Margin >= 20 THEN 'High'
        WHEN Calculated_Profit_Margin >= 10 THEN 'Moderate'
        ELSE 'Low'
    END AS performance_category,
    COUNT(*) AS branch_count
FROM bank_data
GROUP BY performance_category
ORDER BY branch_count DESC;


-- 4.3 CTE: Regions Above 15% Average Profit Margin
-- Which regions have an average profit margin above 15%?

WITH region_profit AS (
    SELECT
        Region,
        AVG(Calculated_Profit_Margin) AS avg_profit_margin
    FROM bank_data
    GROUP BY Region
)
SELECT
    Region,
    avg_profit_margin
FROM region_profit
WHERE avg_profit_margin > 15
ORDER BY avg_profit_margin DESC;


-- 4.4 Window Function: Branch Profitability Ranking
-- How are branches ranked by calculated profit margin?

SELECT
    Branch_ID,
    Calculated_Profit_Margin,
    RANK() OVER (
        ORDER BY Calculated_Profit_Margin DESC
    ) AS profit_rank
FROM bank_data
ORDER BY profit_rank;