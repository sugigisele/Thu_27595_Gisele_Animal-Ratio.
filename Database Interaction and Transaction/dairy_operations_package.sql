-- ==========================================================
--  DAIRY OPERATIONS PACKAGE
-- ==========================================================

-- PART A: PACKAGE SPECIFICATION (The Public Interface)
CREATE OR REPLACE PACKAGE PKG_DAIRY_OPS AS
    -- Custom Exception Definition
    e_invalid_weight EXCEPTION;
    
    -- FUNCTION 1: Lookup Breed Description (Lookup)
    FUNCTION FN_GET_BREED_DESC(p_Breed_ID IN NUMBER) RETURN VARCHAR2;
    
    -- FUNCTION 2: Calculate Feed Ration (Calculation)
    FUNCTION FN_CALC_RATION(p_Cow_ID IN NUMBER) RETURN NUMBER;
    
    -- FUNCTION 3: Validate Cow Weight (Validation)
    FUNCTION FN_IS_WEIGHT_VALID(p_Weight IN NUMBER) RETURN BOOLEAN;

    -- PROCEDURE 1: Register New Cow (DML: Insert)
    PROCEDURE PROC_REGISTER_COW(
        p_Breed_ID IN NUMBER, 
        p_Weight IN NUMBER, 
        p_Status IN VARCHAR2
    );

    -- PROCEDURE 2: Update Feed Stock (DML: Update)
    PROCEDURE PROC_UPDATE_STOCK(
        p_Feed_ID IN NUMBER, 
        p_Qty_Change IN NUMBER
    );

    -- PROCEDURE 3: Bulk Yield Analysis (Cursor & Bulk Collect)
    PROCEDURE PROC_ANALYZE_HERD_PERFORMANCE;
    
END PKG_DAIRY_OPS;
/

-- PART B: PACKAGE BODY (The Implementation)
CREATE OR REPLACE PACKAGE BODY PKG_DAIRY_OPS AS

    -- --------------------------------------------------------
    -- FUNCTION 1: Lookup Breed
    -- --------------------------------------------------------
    FUNCTION FN_GET_BREED_DESC(p_Breed_ID IN NUMBER) RETURN VARCHAR2 IS
        v_Desc BREEDS.Description%TYPE;
    BEGIN
        SELECT Description INTO v_Desc FROM BREEDS WHERE Breed_ID = p_Breed_ID;
        RETURN v_Desc;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 'Unknown Breed';
    END;

    -- --------------------------------------------------------
    -- FUNCTION 2: Calculate Ration
    -- --------------------------------------------------------
    FUNCTION FN_CALC_RATION(p_Cow_ID IN NUMBER) RETURN NUMBER IS
        v_Weight NUMBER;
        v_Status VARCHAR2(20);
    BEGIN
        SELECT Weight_Kg, Lactation_Status INTO v_Weight, v_Status
        FROM CATTLE WHERE Cow_ID = p_Cow_ID;
        
        IF v_Status = 'Milking' THEN RETURN ROUND(v_Weight * 0.035, 2);
        ELSE RETURN ROUND(v_Weight * 0.020, 2);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 0;
    END;

    -- --------------------------------------------------------
    -- FUNCTION 3: Validate Weight
    -- --------------------------------------------------------
    FUNCTION FN_IS_WEIGHT_VALID(p_Weight IN NUMBER) RETURN BOOLEAN IS
    BEGIN
        IF p_Weight BETWEEN 30 AND 1200 THEN RETURN TRUE;
        ELSE RETURN FALSE;
        END IF;
    END;

    -- --------------------------------------------------------
    -- PROCEDURE 1: Register Cow
    -- --------------------------------------------------------
    PROCEDURE PROC_REGISTER_COW(p_Breed_ID IN NUMBER, p_Weight IN NUMBER, p_Status IN VARCHAR2) IS
    BEGIN
        -- Validation
        IF NOT FN_IS_WEIGHT_VALID(p_Weight) THEN
            RAISE e_invalid_weight;
        END IF;

        INSERT INTO CATTLE (Cow_ID, Breed_ID, Birth_Date, Weight_Kg, Lactation_Status)
        VALUES (SEQ_COW_ID.NEXTVAL, p_Breed_ID, SYSDATE, p_Weight, p_Status); -- Assumes Sequence exists
        
        DBMS_OUTPUT.PUT_LINE('Success: Cow Registered.');
    EXCEPTION
        WHEN e_invalid_weight THEN
            PROC_LOG_ERROR('PROC_REGISTER_COW', -20001, 'Weight out of realistic range: ' || p_Weight);
            DBMS_OUTPUT.PUT_LINE('Error: Invalid Weight.');
        WHEN OTHERS THEN
            PROC_LOG_ERROR('PROC_REGISTER_COW', SQLCODE, SQLERRM);
    END;

    -- --------------------------------------------------------
    -- PROCEDURE 2: Update Stock
    -- --------------------------------------------------------
    PROCEDURE PROC_UPDATE_STOCK(p_Feed_ID IN NUMBER, p_Qty_Change IN NUMBER) IS
    BEGIN
        UPDATE FEED_INVENTORY 
        SET Stock_Qty = Stock_Qty + p_Qty_Change
        WHERE Feed_ID = p_Feed_ID;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Feed ID not found.');
        END IF;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Stock Updated.');
    EXCEPTION
        WHEN OTHERS THEN
            PROC_LOG_ERROR('PROC_UPDATE_STOCK', SQLCODE, SQLERRM);
            ROLLBACK;
    END;

    -- --------------------------------------------------------
    -- PROCEDURE 3: Bulk Analysis (Cursors)
    -- --------------------------------------------------------
    PROCEDURE PROC_ANALYZE_HERD_PERFORMANCE IS
        -- Explicit Cursor
        CURSOR c_cows IS SELECT Cow_ID, Weight_Kg FROM CATTLE WHERE Lactation_Status = 'Milking';
        -- Record Type
        TYPE t_cow_list IS TABLE OF c_cows%ROWTYPE;
        v_cows t_cow_list;
    BEGIN
        OPEN c_cows;
        FETCH c_cows BULK COLLECT INTO v_cows; -- Optimization: Bulk Collect
        CLOSE c_cows;

        FOR i IN 1 .. v_cows.COUNT LOOP
            -- Logic: Just printing for demo, normally would do complex math
            DBMS_OUTPUT.PUT_LINE('Analyzing Cow: ' || v_cows(i).Cow_ID);
        END LOOP;
    END;

END PKG_DAIRY_OPS;
/
