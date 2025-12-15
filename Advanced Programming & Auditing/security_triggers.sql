-- ==========================================================
-- SECURITY TRIGGERS & RULES
-- ==========================================================

-- 1. RESTRICTION CHECK FUNCTION
-- Returns TRUE only if today is SAT or SUN
CREATE OR REPLACE FUNCTION FN_IS_WORK_PERMITTED RETURN BOOLEAN IS
    v_Day_Str VARCHAR2(20);
    v_Holiday_Count NUMBER;
BEGIN
    -- Check 1: Get the day abbreviation (MON, TUE, WED...)
    v_Day_Str := TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');
    
    -- If it is NOT Saturday or Sunday, Block it.
    IF v_Day_Str NOT IN ('SAT', 'SUN') THEN
        RETURN FALSE; 
    END IF;

    -- Check 2: Is it a Holiday?
    SELECT COUNT(*) INTO v_Holiday_Count 
    FROM HOLIDAYS 
    WHERE TRUNC(Holiday_Date) = TRUNC(SYSDATE);
    
    IF v_Holiday_Count > 0 THEN
        RETURN FALSE; 
    END IF;

    RETURN TRUE; 
END;
/

-- 2. COMPOUND TRIGGER ON MILK_PRODUCTION
-- This trigger fires whenever you try to Insert, Update, or Delete
CREATE OR REPLACE TRIGGER TRG_SECURE_MILK_LOGS
FOR INSERT OR UPDATE OR DELETE ON MILK_PRODUCTION
COMPOUND TRIGGER

    -- Variables
    v_Action VARCHAR2(20);
    v_Is_Permitted BOOLEAN;

    -- BEFORE STATEMENT: Checks the date BEFORE doing anything
    BEFORE STATEMENT IS
    BEGIN
        -- Determine Action Name
        IF INSERTING THEN v_Action := 'INSERT';
        ELSIF UPDATING THEN v_Action := 'UPDATE';
        ELSIF DELETING THEN v_Action := 'DELETE';
        END IF;

        -- Check the Rule
        v_Is_Permitted := FN_IS_WORK_PERMITTED;

        IF NOT v_Is_Permitted THEN
            -- 1. Log the failed attempt to the Audit table
            PROC_LOG_AUDIT(v_Action, 'MILK_PRODUCTION', 'N', 'Attempted on a Restricted Day (' || TO_CHAR(SYSDATE, 'DY') || ')');
            
            -- 2. STOP the transaction with an error
            RAISE_APPLICATION_ERROR(-20005, 'SECURITY ALERT: Modifications are only allowed on Weekends (Sat/Sun). Today is ' || TO_CHAR(SYSDATE, 'DY'));
        ELSE
            -- Log the successful attempt
            PROC_LOG_AUDIT(v_Action, 'MILK_PRODUCTION', 'Y', 'Access Granted');
        END IF;
    END BEFORE STATEMENT;

END TRG_SECURE_MILK_LOGS;
/
