-- ==========================================================
-- ERROR LOGGING INFRASTRUCTURE
-- ==========================================================

-- 1. Create a table to store system errors
CREATE TABLE ERROR_LOGS (
    Log_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Error_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Subprogram_Name VARCHAR2(100),
    Error_Code NUMBER,
    Error_Message VARCHAR2(4000),
    User_Name VARCHAR2(50)
);

-- 2. Create a generic procedure to write to this log
-- (We call this from inside other procedures when they fail)
CREATE OR REPLACE PROCEDURE PROC_LOG_ERROR 
    (p_Prog_Name IN VARCHAR2, p_Code IN NUMBER, p_Msg IN VARCHAR2) 
IS
    PRAGMA AUTONOMOUS_TRANSACTION; -- Saves log even if main txn fails
BEGIN
    INSERT INTO ERROR_LOGS (Subprogram_Name, Error_Code, Error_Message, User_Name)
    VALUES (p_Prog_Name, p_Code, p_Msg, USER);
    COMMIT;
END;
/
