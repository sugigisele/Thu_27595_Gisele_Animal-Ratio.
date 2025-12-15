-- ==========================================================
-- SCRIPT 4: TESTING & VALIDATION QUERIES
-- OBJECTIVE: Verify data integrity and business rules
-- ==========================================================

-- TEST 1: Basic Retrieval & Join
-- "List all cows with their breed name and current weight"
SELECT 
    c.Cow_ID, 
    b.Breed_Name, 
    c.Weight_Kg, 
    c.Lactation_Status
FROM CATTLE c
JOIN BREEDS b ON c.Breed_ID = b.Breed_ID
ORDER BY c.Weight_Kg DESC;

-- TEST 2: Aggregation (GROUP BY)
-- "Calculate the average milk yield per breed"
SELECT 
    b.Breed_Name,
    COUNT(DISTINCT c.Cow_ID) AS Number_Of_Cows,
    ROUND(AVG(m.Yield_Liters), 2) AS Avg_Daily_Yield
FROM BREEDS b
JOIN CATTLE c ON b.Breed_ID = c.Breed_ID
JOIN MILK_PRODUCTION m ON c.Cow_ID = m.Cow_ID
GROUP BY b.Breed_Name;

-- TEST 3: Complex Subquery
-- "Find cows that produce MORE than the herd average"
SELECT Cow_ID, Yield_Liters, Milking_Date
FROM MILK_PRODUCTION
WHERE Yield_Liters > (SELECT AVG(Yield_Liters) FROM MILK_PRODUCTION)
ORDER BY Yield_Liters DESC;

-- TEST 4: Data Integrity Check (Edge Cases)
-- "Show feed inventory value (Quantity * Density)"
SELECT 
    Feed_Name, 
    Stock_Qty, 
    Energy_Density, 
    (Stock_Qty * Energy_Density) AS Total_Energy_Available
FROM FEED_INVENTORY
WHERE Stock_Qty > 0;
