-- ==========================================================
-- SCRIPT 3: DATA INSERTION (RE-TRY)
-- AUTHOR: Sugi Gisele
-- ==========================================================

-- 1. POPULATE LOOKUP TABLES (Static Data)
INSERT INTO BREEDS VALUES (1, 'Holstein', 'High milk production, large body size.');
INSERT INTO BREEDS VALUES (2, 'Jersey', 'High butterfat content, smaller body.');
INSERT INTO BREEDS VALUES (3, 'Ayrshire', 'Hardy breed, good foragers.');
INSERT INTO BREEDS VALUES (4, 'Guernsey', 'Produces milk with high beta-carotene.');

INSERT INTO FEED_INVENTORY VALUES (10, 'Corn Silage', 5000, 1.60);
INSERT INTO FEED_INVENTORY VALUES (20, 'Alfalfa Hay', 2000, 1.35);
INSERT INTO FEED_INVENTORY VALUES (30, 'Soybean Meal', 1500, 2.10);
INSERT INTO FEED_INVENTORY VALUES (40, 'Barley Grain', 3000, 1.90);
INSERT INTO FEED_INVENTORY VALUES (50, 'Mineral Mix', 500, 0.00);

COMMIT;

-- 2. GENERATE 100 COWS (PL/SQL Loop)
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO CATTLE (Cow_ID, Breed_ID, Birth_Date, Weight_Kg, Lactation_Status)
    VALUES (
       100 + i,                            
       ROUND(DBMS_RANDOM.VALUE(1, 4)),     
       SYSDATE - DBMS_RANDOM.VALUE(700, 2500), 
       ROUND(DBMS_RANDOM.VALUE(450, 750), 2),  
       CASE WHEN DBMS_RANDOM.VALUE(0, 1) > 0.2 THEN 'Milking' ELSE 'Dry' END
    );
  END LOOP;
  COMMIT;
END;
/

-- 3. GENERATE MILK LOGS
BEGIN
  FOR c IN (SELECT Cow_ID FROM CATTLE WHERE Lactation_Status = 'Milking') LOOP
     FOR d IN 1..10 LOOP
       INSERT INTO MILK_PRODUCTION (Log_ID, Cow_ID, Milking_Date, Yield_Liters)
       VALUES (
          (c.Cow_ID * 100) + d,  
          c.Cow_ID,
          SYSDATE - d,           
          ROUND(DBMS_RANDOM.VALUE(15, 40), 2) 
       );
     END LOOP;
  END LOOP;
  COMMIT;
END;
/

-- VERIFICATION (Take a screenshot of this result!)
SELECT 
    (SELECT COUNT(*) FROM CATTLE) AS Total_Cows,
    (SELECT COUNT(*) FROM MILK_PRODUCTION) AS Total_Milk_Logs
FROM DUAL;
