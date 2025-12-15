-- ==========================================================
--  SECURITY INFRASTRUCTURE
-- ==========================================================

-- 1. HOLIDAY MANAGEMENT TABLE
-- Stores dates when work is strictly forbidden
CREATE TABLE HOLIDAYS (
    Holiday_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Holiday_Date DATE UNIQUE NOT NULL,
    Reason VARCHAR2(100)
);

-- Insert upcoming New Year as a holiday
INSERT INTO HOLIDAYS (Holiday_Date, Reason) VALUES (TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'New Year');
COMMIT;

-- 2. AUDIT LOG TABLE
-- Records every attempt to modify the database
CREATE TABLE AUDIT_LOGS (
    Audit_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    User_Name VARCHAR2(50),
    Action_Type VARCHAR2(20),   -- INSERT, UPDATE, DELETE
    Table_Name VARCHAR2(50),
    Attempt_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Was_Allowed CHAR(1),        -- 'Y' or 'N'
    Details VARCHAR2(4000)
);

-- 3. AUDIT LOGGING PROCEDURE
-- Saves the log entry even if the main transaction fails
CREATE OR REPLACE PROCEDURE PROC_LOG_AUDIT 
    (p_Action IN VARCHAR2, p_Table IN VARCHAR2, p_Allowed IN CHAR, p_Msg IN VARCHAR2) 
IS
    PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN
    INSERT INTO AUDIT_LOGS (User_Name, Action_Type, Table_Name, Was_Allowed, Details)
    VALUES (USER, p_Action, p_Table, p_Allowed, p_Msg);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;
/
