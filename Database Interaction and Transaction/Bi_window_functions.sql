 BI ANALYTICS (WINDOW FUNCTIONS)
-- ==========================================================

-- 1. RANKING: Who are the top 3 performing cows PER BREED?
SELECT * FROM (
    SELECT 
        b.Breed_Name,
        c.Cow_ID,
        AVG(m.Yield_Liters) as Avg_Yield,
        RANK() OVER (PARTITION BY b.Breed_Name ORDER BY AVG(m.Yield_Liters) DESC) as Breed_Rank
    FROM CATTLE c
    JOIN BREEDS b ON c.Breed_ID = b.Breed_ID
    JOIN MILK_PRODUCTION m ON c.Cow_ID = m.Cow_ID
    GROUP BY b.Breed_Name, c.Cow_ID
) 
WHERE Breed_Rank <= 3;

-- 2. TREND ANALYSIS: Compare today's yield vs yesterday's (LAG)
-- This shows if a cow is improving or declining day-by-day
SELECT 
    Cow_ID,
    Milking_Date,
    Yield_Liters,
    LAG(Yield_Liters, 1, 0) OVER (PARTITION BY Cow_ID ORDER BY Milking_Date) as Previous_Day_Yield,
    ROUND(Yield_Liters - LAG(Yield_Liters, 1, 0) OVER (PARTITION BY Cow_ID ORDER BY Milking_Date), 2) as Daily_Change
FROM MILK_PRODUCTION
ORDER BY Cow_ID, Milking_Date DESC
FETCH FIRST 20 ROWS ONLY;

-- 3. AGGREGATES: Running Total of Milk Production per Cow
SELECT 
    Cow_ID,
    Milking_Date,
    Yield_Liters,
    SUM(Yield_Liters) OVER (PARTITION BY Cow_ID ORDER BY Milking_Date) as Running_Total_Yield
FROM MILK_PRODUCTION
FETCH FIRST 20 ROWS ONLY;
