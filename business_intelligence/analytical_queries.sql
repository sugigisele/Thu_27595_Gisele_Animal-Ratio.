-- ==========================================================
-- SCRIPT: BI DASHBOARD QUERIES
-- AUTHOR: Sugi Gisele
-- ==========================================================

-- 1. DATA FOR EXECUTIVE DASHBOARD (KPI Cards)
-- Calculates active cows, average yield, and feed stock status
SELECT 
    (SELECT COUNT(*) FROM CATTLE WHERE Lactation_Status = 'Milking') AS Active_Cows,
    (SELECT ROUND(AVG(Yield_Liters),2) FROM MILK_PRODUCTION WHERE Milking_Date > SYSDATE - 1) AS Avg_Yield_Yesterday,
    (SELECT ROUND(SUM(Stock_Qty)/500, 0) FROM FEED_INVENTORY) AS Est_Feed_Days_Left
FROM DUAL;

-- 2. DATA FOR AUDIT DASHBOARD (Violation Counts)
-- Counts how many times the security trigger blocked an action
SELECT 
    Action_Type,
    COUNT(*) as Violation_Count
FROM AUDIT_LOGS 
WHERE Was_Allowed = 'N'
GROUP BY Action_Type;

-- 3. DATA FOR PERFORMANCE DASHBOARD (Storage Usage)
-- Shows how much space your tablespaces are using
SELECT 
    Tablespace_Name, 
    Segment_Type, 
    COUNT(*) as Objects, 
    SUM(Bytes)/1024/1024 as Size_MB
FROM USER_SEGMENTS
GROUP BY Tablespace_Name, Segment_Type;
