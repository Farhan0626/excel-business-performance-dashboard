
USE MIS_Analytics;
GO

-- =============================================
-- QUESTION 1: Find the Top 5 Customers by Total Revenue
-- Tables: Sales and Customer_Master
-- =============================================

SELECT TOP 5
    C.Customer_ID,
    C.Customer_Name,
    SUM(S.Amount) AS Total_Revenue,
    COUNT(S.Order_ID) AS Total_Orders
FROM Sales S
INNER JOIN Customer_Master C
    ON S.Customer_ID = C.Customer_ID
WHERE C.Customer_Name IS NOT NULL
GROUP BY C.Customer_ID, C.Customer_Name
ORDER BY Total_Revenue DESC;
GO


-- =============================================
-- QUESTION 2: Find Overdue Payments by Region
-- Tables: Finance and Sales
-- =============================================

SELECT
    S.Region,
    COUNT(F.Invoice_ID) AS Overdue_Invoices,
    SUM(F.Amount) AS Overdue_Amount
FROM Finance F
INNER JOIN Sales S
    ON F.Order_ID = S.Order_ID
WHERE F.Due_Date < GETDATE()
  AND F.Payment_Status <> 'Paid'
GROUP BY S.Region
ORDER BY Overdue_Amount DESC;
GO


-- =============================================
-- QUESTION 3: Analyze the Lead-to-Sale Conversion Funnel
-- Tables: CRM and Sales
-- =============================================

SELECT
    C.Lead_Status,
    COUNT(DISTINCT C.Lead_ID) AS Total_Leads,
    COUNT(DISTINCT S.Customer_ID) AS Customers_With_Sales
FROM CRM C
LEFT JOIN Sales S
    ON C.Customer_ID = S.Customer_ID
GROUP BY C.Lead_Status
ORDER BY Total_Leads DESC;
GO


-- =============================================
-- QUESTION 4: Analyze Monthly Sales Performance by Region
-- Table: Sales
-- =============================================

SELECT
    Region,
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Amount) AS Total_Revenue
FROM Sales
GROUP BY
    Region,
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Sales_Year,
    Sales_Month,
    Region;
GO


-- =============================================
-- QUESTION 5: Analyze Fulfillment Performance by Warehouse
-- Table: Operations
-- =============================================

SELECT
    Warehouse_ID,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    AVG(fullfillment_days) AS Average_Fulfillment_Days,
    MIN(fullfillment_days) AS Minimum_Days,
    MAX(fullfillment_days) AS Maximum_Days
FROM Operations
GROUP BY Warehouse_ID
ORDER BY Average_Fulfillment_Days;
GO
