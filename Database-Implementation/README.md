# Phase IV: Database Implementation
**Project:** Domestic Animal Ration Calculator (Cow)
**Student Name:** Sugi Gisele
**Student ID:** 27595
**Group:** THUS

## 1. Database Specifications
This repository contains the initialization scripts for the Oracle Pluggable Database (PDB) designed to support the Ration Calculator application.

* **Database Name:** `THUS_27595_GISELE_COWCALC_DB`
* **Admin User:** `ADMIN_GISELE`
* **Privileges:** DBA (Super Admin)

## 2. Storage Architecture
The database utilizes custom tablespaces to separate business data from system overhead and indexes:

* **`TBS_COW_DATA`**: Stores the core entities (Cattle, Milk Logs, Feed Inventory).
* **`TBS_COW_IDX`**: Stores indexes to optimize lookups on `Cow_ID` and `Breed_ID`.
* **`TEMP`**: Customized temporary tablespace for sorting operations.

## 3. Configuration & Security
* **Memory:** SGA (500MB) and PGA (200MB) configured for efficient calculation processing.
* **Reliability:** Archive logging is enabled, and all datafiles are set to `AUTOEXTEND` to prevent storage exhaustion during the exam evaluation.

## 4. How to Run These Scripts
1.  **System Setup:** Run `01_database_setup.sql` as a SYSDBA user to create the PDB and user accounts.
2.  **Schema Build:** Connect as `ADMIN_GISELE` and run `02_schema_objects.sql` to build the tables and relationships.
