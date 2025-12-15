-- ==========================================================
-- TESTING SECURITY (MUST FAIL ON WEEKDAYS)
-- ==========================================================

-- TEST 1: Attempt to Insert Data (Should be BLOCKED)
-- We try to add a fake milk log.
-- EXPECTED RESULT: ORA-20005: SECURITY ALERT...
BEGIN
    INSERT INTO MILK_PRODUCTION (Log_ID, Cow_ID, Yield_Liters)
    VALUES (99999, 105, 25.5);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Test 1 Result: BLOCKED AS EXPECTED.');
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END;
/

-- TEST 2: Check the Audit Log
-- This proves the system "caught" you trying to break the rules.
SELECT User_Name, Action_Type, Was_Allowed, Details, Attempt_Date 
FROM AUDIT_LOGS 
ORDER BY Audit_ID DESC;
