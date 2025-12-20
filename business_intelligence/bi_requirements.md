# Business Intelligence Requirements
**Project:** Domestic Animal Ration Calculator
**Student:** Sugi Gisele (27595)

## 1. Stakeholders & Needs
| Stakeholder | Role | Decision Support Need |
|:---|:---|:---|
| **Farm Manager** | Strategic | Which cows should be culled due to low production? |
| **Nutritionist** | Operational | Is the current feed ration resulting in higher milk yield? |
| **IT Auditor** | Compliance | Are employees accessing data during restricted hours? |
| **Veterinarian** | Health | Which cows show a sudden drop in yield (health alert)? |

## 2. Reporting Frequency
* **Real-Time:** Security Alerts (Unauthorized Access), Low Yield Triggers.
* **Daily:** Milk Production Log, Feed Inventory Levels.
* **Monthly:** Financial Profitability Analysis, Herd Fertility Trends.

## 3. Key Performance Indicators (KPIs)
* **KPI 1: Average Daily Yield (ADY)**
    * *Target:* > 25 Liters/Cow
    * *Formula:* `SUM(Daily_Yield) / COUNT(Milking_Cows)`
    * *Purpose:* Measures overall herd efficiency.
* **KPI 2: Feed Conversion Efficiency (FCE)**
    * *Target:* > 1.4 (1.4L milk per 1kg feed)
    * *Formula:* `Milk_Output_Kg / Feed_Input_Kg`
    * *Purpose:* Ensures feed costs are justified by production.
* **KPI 3: Security Compliance Score**
    * *Target:* 100%
    * *Formula:* `(Total_Attempts - Denied_Attempts) / Total_Attempts`
    * *Purpose:* Monitors adherence to the "Weekend-Only" work policy.
