-- Create database for the project
CREATE DATABASE telco_churn;

-- Use the database
USE telco_churn;

-- Check total rows
SELECT COUNT(*) FROM telco_customers;

-- Preview data
SELECT * FROM telco_customers LIMIT 10;

-- Remove rows with missing total charges
DELETE FROM telco_customers
WHERE TotalCharges IS NULL OR TotalCharges = '';

-- Convert TotalCharges to numeric
ALTER TABLE telco_customers
MODIFY TotalCharges DECIMAL(10,2);

-- Convert churn into numeric flag
ALTER TABLE telco_customers ADD churn_flag INT;

UPDATE telco_customers
SET churn_flag = CASE 
    WHEN Churn = 'Yes' THEN 1 
    ELSE 0 
END;

-- Overall churn rate
SELECT 
    ROUND(AVG(churn_flag) * 100, 2) AS churn_percentage
FROM telco_customers;

-- Churn by Contract Type
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(churn_flag) AS churned_customers,
    ROUND(AVG(churn_flag) * 100, 2) AS churn_rate
FROM telco_customers
GROUP BY Contract;

-- Churn by Monthly Charges
SELECT 
    CASE 
        WHEN MonthlyCharges < 40 THEN 'Low'
        WHEN MonthlyCharges BETWEEN 40 AND 80 THEN 'Medium'
        ELSE 'High'
    END AS charge_segment,
    COUNT(*) AS customers,
    ROUND(AVG(churn_flag) * 100, 2) AS churn_rate
FROM telco_customers
GROUP BY charge_segment;

-- Create Final Analytics Table
CREATE TABLE churn_analysis AS
SELECT
    customerID,
    tenure,
    MonthlyCharges,
    TotalCharges,
    Contract,
    PaymentMethod,
    churn_flag
FROM telco_customers;

SELECT * FROM churn_analysis;