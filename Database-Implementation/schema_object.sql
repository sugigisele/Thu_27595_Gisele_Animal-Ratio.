-- ==========================================================
-- SCRIPT 3: SCHEMA OBJECTS
-- USER: ADMIN_GISELE
-- ==========================================================

-- 1. Reference Table: BREEDS
CREATE TABLE BREEDS (
    Breed_ID NUMBER PRIMARY KEY,
    Breed_Name VARCHAR2(50) NOT NULL,
    Description VARCHAR2(200)
) TABLESPACE TBS_COW_DATA;

-- 2. Main Table: CATTLE
CREATE TABLE CATTLE (
    Cow_ID NUMBER PRIMARY KEY,
    Breed_ID NUMBER,
    Birth_Date DATE NOT NULL,
    Weight_Kg NUMBER(5,2) CHECK (Weight_Kg > 0),
    Lactation_Status VARCHAR2(20),
    CONSTRAINT fk_cattle_breed FOREIGN KEY (Breed_ID) REFERENCES BREEDS(Breed_ID),
    CONSTRAINT chk_lactation_status CHECK (Lactation_Status IN ('Dry', 'Milking'))
) TABLESPACE TBS_COW_DATA;

-- 3. Production Table: MILK_PRODUCTION
CREATE TABLE MILK_PRODUCTION (
    Log_ID NUMBER PRIMARY KEY,
    Cow_ID NUMBER,
    Milking_Date DATE DEFAULT SYSDATE,
    Yield_Liters NUMBER(4,2) CHECK (Yield_Liters > 0),
    CONSTRAINT fk_milk_cow FOREIGN KEY (Cow_ID) REFERENCES CATTLE(Cow_ID)
) TABLESPACE TBS_COW_DATA;

-- 4. Inventory Table: FEED_INVENTORY
CREATE TABLE FEED_INVENTORY (
    Feed_ID NUMBER PRIMARY KEY,
    Feed_Name VARCHAR2(50) UNIQUE,
    Stock_Qty NUMBER(8,2) CHECK (Stock_Qty >= 0),
    Energy_Density NUMBER(4,2) 
) TABLESPACE TBS_COW_DATA;

-- 5. Index Creation
CREATE INDEX IDX_CATTLE_BREED ON CATTLE(Breed_ID) TABLESPACE TBS_COW_IDX;
CREATE INDEX IDX_MILK_COW ON MILK_PRODUCTION(Cow_ID) TABLESPACE TBS_COW_IDX;

-- PROOF STEP: List all tables created
SELECT TABLE_NAME, TABLESPACE_NAME FROM USER_TABLES;
