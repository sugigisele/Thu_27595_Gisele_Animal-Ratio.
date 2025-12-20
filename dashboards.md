# Dashboard Mockups

## 1. Executive Summary (The Morning View)
*Audience: Farm Manager | Refresh: Daily @ 6:00 AM*

| **Total Active Herd** | **Avg Yield Yesterday** | **Feed Days Remaining** |
|:---:|:---:|:---:|
| 🟢 **100** Cows | 🟡 **27.5** L (↓ 2%) | 🟢 **14** Days |

**Trend Analysis (Last 7 Days)**
> `[Graph Placeholder: Line chart showing daily milk totals]`
> *Insight: Production dipped on Dec 12th due to temperature drop.*

---

## 2. Audit & Security Dashboard
*Audience: IT Admin | Refresh: Real-time*

**Violation Summary (This Month)**
| Metric | Count | Status |
|:---|:---:|:---|
| Weekday Insert Attempts | **2** | 🔴 CRITICAL |
| Holiday Modifications | **1** | 🟡 WARNING |
| After-Hours Login | **0** | 🟢 GOOD |

**Recent Access Log**
| Time | User | Action | Result |
|:---|:---|:---|:---|
| 09:15 AM | ADMIN_GISELE | INSERT | **DENIED** |
| 09:10 AM | ADMIN_GISELE | UPDATE | **DENIED** |

---

## 3. Performance Dashboard (Resource Usage)
*Audience: DBA | Refresh: Weekly*

**Database Storage Health**
| Tablespace | Size MB | Used MB | % Free |
|:---|:---:|:---:|:---:|
| TBS_COW_DATA | 100 | 45 | 55% |
| TBS_COW_IDX | 50 | 12 | 76% |

**Top Resource Consumers**
1. `PROC_ANALYZE_HERD` (High CPU - Bulk Collect)
2. `TRG_SECURE_MILK_LOGS` (High Frequency - Trigger)
