## Logical Data Model Design
**Project:** The Domestic Animal Calculator (Cow)
**Date:** December 9, 2025
**Group:** D
## NAMES: SUGI GISELE

---

## 1. Entity-Relationship Model (ERD)
The logical model is designed to support high-frequency transactional data (daily milk logs) while maintaining strict referential integrity for the nutritional calculation engine.

## DIAGRAM .

### Logical Diagram
```mermaid
erDiagram
    CATTLE_BREEDS ||--|{ CATTLE : "defines_genetic_traits"
    CATTLE ||--|{ MILK_PRODUCTION : "logs_daily_yield"
    CATTLE ||--|{ FEEDING_EVENTS : "consumes"
    FEED_INVENTORY ||--|{ FEEDING_EVENTS : "is_used_in"

    CATTLE_BREEDS {
        int Breed_ID PK
        string Breed_Name
        float Target_Yield
    }
    CATTLE {
        int Cow_ID PK
        int Breed_ID FK
        date Birth_Date
        float Weight_Kg
    }
    MILK_PRODUCTION {
        int Log_ID PK
        int Cow_ID FK
        date Milking_Date
        float Yield_Liters
    }
    FEED_INVENTORY {
        int Feed_ID PK
        string Item_Name
        float Stock_Qty
    }
       
  '''

### Key Entities & Cardinalities
* **CATTLE_BREEDS (1) ────< (N) CATTLE:**
    * One Breed can represent many Cows.
    * A Cow must belong to exactly one Breed (Mandatory).
* **CATTLE (1) ────< (N) MILK_PRODUCTION:**
    * One Cow has many daily Milk Logs.
    * A Milk Log must be assigned to one specific Cow.
* **FEED_INVENTORY (1) ────< (N) FEEDING_LOGS >──── (1) CATTLE:**
    * This is a **Many-to-Many** relationship resolved via the associative table `FEEDING_LOGS`.
    * One Cow eats many Feeds; One Feed type is fed to many Cows.

---

## 2. Normalization Strategy
To ensure data integrity and reduce redundancy, the schema is normalized to **3rd Normal Form (3NF)**.

* **1NF (First Normal Form):**
    * All attributes are atomic. We do not store multiple feed types in a single cell (e.g., "Corn, Hay"). Instead, specific feeding events are broken down into rows in the `FEEDING_LOGS` table.
* **2NF (Second Normal Form):**
    * All non-key attributes are fully dependent on the Primary Key. For example, in `MILK_PRODUCTION`, the `Fat_Percentage` depends on the specific milking event (Date + Cow), not just the Cow.
* **3NF (Third Normal Form):**
    * Transitive dependencies have been removed. Attributes like `Breed_Origin` and `Average_Yield_Target` were moved out of the `CATTLE` table and into a separate `CATTLE_BREEDS` reference table. This prevents data anomalies if breed standards change.

---

## 3. Data Dictionary

### Table: CATTLE
| Attribute | Data Type | Key | Constraints | Description |
| :--- | :--- | :--- | :--- | :--- |
| `Cow_ID` | NUMBER | PK | Sequence | Unique identifier for the animal (Tag Number). |
| `Breed_ID` | NUMBER | FK | Not Null | Link to genetic breed data. |
| `Birth_Date` | DATE | | Not Null | Used to calculate dynamic age. |
| `Weight_Kg` | NUMBER(5,2) | | > 0 | Current weight, critical for ration calc. |
| `Lactation_Status` | VARCHAR2(20) | | IN ('Dry','Milking') | Current production status. |

### Table: MILK_PRODUCTION
| Attribute | Data Type | Key | Constraints | Description |
| :--- | :--- | :--- | :--- | :--- |
| `Log_ID` | NUMBER | PK | Sequence | Unique transaction ID. |
| `Cow_ID` | NUMBER | FK | | The cow being milked. |
| `Milking_Date` | DATE | | Default SYSDATE | Date of production. |
| `Yield_Liters` | NUMBER(4,2) | | Check > 0 | The volume of milk produced. |

### Table: FEED_INVENTORY
| Attribute | Data Type | Key | Constraints | Description |
| :--- | :--- | :--- | :--- | :--- |
| `Feed_ID` | NUMBER | PK | Sequence | Unique feed identifier. |
| `Feed_Name` | VARCHAR2(50) | | Unique | e.g., "Corn Silage", "Soybean Meal". |
| `Stock_Qty` | NUMBER(8,2) | | >= 0 | Current inventory level in Kg. |
| `Energy_Density` | NUMBER(4,2) | | | Mcal/Kg (Nutritional value). |

---

## 4. BI Considerations (Analytics)
The database is designed to support future Business Intelligence queries.

* **Fact Tables (Measures):**
    * `MILK_PRODUCTION`: Acts as the primary Fact table containing numerical performance data (Yield, Fat, Protein).
* **Dimension Tables (Context):**
    * `CATTLE`: Provides dimensions for Age, Breed, and Health Status.
    * `TIME`: Derived from `Milking_Date` to allow drilling down by Week, Month, or Season.
* **Audit Trails:**
    * A `FEED_AUDIT` table (planned) will track manual adjustments to inventory to prevent theft or loss.

## 5. Assumptions
1.  **Single Farm:** The system is currently designed for a single location; multi-farm support would require a `Farm_ID` column.
2.  **Daily Aggregation:** If cows are milked twice a day, the system assumes the input is the *total* sum for the day, or entries are entered as separate rows.
