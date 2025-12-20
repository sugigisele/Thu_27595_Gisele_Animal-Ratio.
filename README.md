# Domestic Animal Ration Calculator (Cow)
### Oracle PL/SQL Capstone Project

**Student Name:** Sugi Gisele
**Student ID:** 27595
**Group:** THUS
**Course:** Database Management Systems & PL/SQL

---

## 1. Project Overview
The **Domestic Animal Ration Calculator** is a robust database application designed to assist dairy farmers in optimizing milk production and feed costs. It automates the calculation of daily feed rations based on cow weight and lactation status, tracks milk yield trends using Business Intelligence (BI), and enforces strict security protocols for data modification.

**Problem Statement:**
Manual calculation of feed rations is prone to error and inefficient. This system provides a centralized database to manage herd demographics, track milk production logs, and automatically calculate nutritional needs using PL/SQL stored procedures.

## 2. Key Objectives
* **Data Management:** Efficiently store herd demographics, milk logs, and feed inventory.
* **Automation:** Automatically calculate feed requirements using PL/SQL stored functions.
* **Intelligence:** Analyze long-term fertility and production trends using Window Functions.
* **Security:** Enforce "Weekend-Only" modification rules using Compound Triggers and Audit Logging.

## 3. Repository Structure
This repository is organized by project phase:

| Folder Name | Description |
|:---|:---|
| **Logical_Data_Model** | Contains the ER Diagram and conceptual design. |
| **Database-Implementation** | Phase IV: Scripts to create the PDB and Tablespaces. |
| **Table Implementation and Data Insertion** | Phase V: Schema creation and PL/SQL data generation scripts. |
| **Database Interaction and Transaction** | Phase VI: PL/SQL Packages, Functions, and Procedures. |
| **Advanced Programming & Auditing** | Phase VII: Security Triggers, Holiday Management, and Auditing. |
| **business_intelligence** | Phase VIII: BI Dashboards, KPIs, and Analytical Queries. |

## 4. Quick Start (Installation Order)
To replicate this project, execute the SQL scripts in the following order:

1.  **Database Setup:** Run scripts in `Database-Implementation` (Requires SYSDBA privileges).
2.  **Schema Build:** Run scripts in `Table Implementation...` to create tables and insert dummy data.
3.  **Deploy Logic:** Run the Package scripts in `Database Interaction...` to install the PL/SQL core.
4.  **Apply Security:** Run the Trigger scripts in `Advanced Programming...` to enable the weekend-only lock.
5.  **Analyze:** Run the queries in `business_intelligence` to view the dashboards.

## 5. Technology Stack
* **Database:** Oracle Database 21c (Pluggable Database)
* **Language:** SQL, PL/SQL
* **Tools:** Oracle SQL Developer, GitHub

---
##  Sugi Gisele. 
