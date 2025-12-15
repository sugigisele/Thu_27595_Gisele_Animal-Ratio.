
-- ==========================================================
-- SCRIPT 1: DATABASE SETUP & CONFIGURATION
-- PROJECT: Domestic Animal Ration Calculator
-- STUDENT: Sugi Gisele (ID: 27595)
-- GROUP: THUS
-- ==========================================================

-- PART A: PLUGGABLE DATABASE CREATION
-- Connect as SYSDBA before running this section.

CREATE PLUGGABLE DATABASE THUS_27595_GISELE_COWCALC_DB
ADMIN USER ADMIN_GISELE IDENTIFIED BY Gisele
ROLES = (DBA)
FILE_NAME_CONVERT = ('pdbseed', 'thus_cowcalc');

-- Open the new database
ALTER PLUGGABLE DATABASE THUS_27595_GISELE_COWCALC_DB OPEN;

-- Switch to the new container
ALTER SESSION SET CONTAINER = THUS_27595_GISELE_COWCALC_DB;

-- PART B: STORAGE CONFIGURATION (TABLESPACES)

-- 1. Main Data Tablespace
CREATE TABLESPACE TBS_COW_DATA
DATAFILE 'cow_data01.dbf' SIZE 100M 
AUTOEXTEND ON NEXT 10M MAXSIZE 2G;

-- 2. Index Tablespace
CREATE TABLESPACE TBS_COW_IDX
DATAFILE 'cow_idx01.dbf' SIZE 50M 
AUTOEXTEND ON NEXT 5M MAXSIZE 1G;

-- 3. Temporary Tablespace Configuration
-- (Conditional logic to create or resize temp file)
DECLARE
  v_count NUMBER;
BEGIN
  SELECT count(*) INTO v_count FROM dba_temp_files WHERE file_name LIKE '%cow_temp01.dbf%';
  IF v_count = 0 THEN
    EXECUTE IMMEDIATE 'ALTER TABLESPACE TEMP ADD TEMPFILE ''cow_temp01.dbf'' SIZE 50M AUTOEXTEND ON NEXT 5M MAXSIZE 500M';
  END IF;
END;
/

-- PART C: USER & SYSTEM CONFIGURATION

-- Set default storage for the Admin User
ALTER USER ADMIN_GISELE DEFAULT TABLESPACE TBS_COW_DATA;

-- Optimize Memory for Calculations
ALTER SYSTEM SET SGA_TARGET = 500M SCOPE = SPFILE;
ALTER SYSTEM SET PGA_AGGREGATE_TARGET = 200M SCOPE = SPFILE;
