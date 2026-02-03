# End-to-End E-Commerce Analytics Warehouse  
### A Production-Grade SQL ETL & Business Intelligence System

---

## Executive Overview

This project demonstrates a **production-style, end-to-end Analytics Engineering workflow**, transforming raw e-commerce transactional data into **executive-ready business intelligence**.

Built on a public e-commerce dataset containing **~99K orders**, the focus is not ad-hoc querying but **structured SQL modeling, defensive data engineering, and business storytelling** through dashboards.

The system follows a **clear 8-step Analytics Framework**, moving from:
**Business problem framing → data modeling → data quality validation → semantic SQL views → BI dashboards**.

---

## Tech Stack

- **Database**: PostgreSQL  
- **Data Modeling**: Modular SQL (Staging → Fact/Dimensions → Analytical Views)  
- **BI Tool**: Power BI  
- **Design Philosophy**: Single Source of Truth (SSOT) via SQL Views  

---

## Project Motivation (The “Why”)

In real-world e-commerce environments, data arrives **dirty, fragmented, and siloed**.  
A simple SQL query is not enough—organizations need a **Single Source of Truth** to make reliable, high-impact decisions.

**The Mission:**  
Transform raw transactional data into a **structured, audited, and tool-agnostic analytics warehouse** that can support Finance, Operations, and Marketplace teams without metric inconsistencies.

This project moves beyond “writing queries” into **Analytics Engineering**—standardizing data so every stakeholder sees the same reality.

---

## What This System Does

This repository implements a **full ELT analytics pipeline**:

- **Ingestion & Staging**: Raw data ingested as `TEXT` to prevent pipeline failure  
- **Defensive Engineering**: Text standardization, NULL handling, and temporal validation  
- **Star Schema Architecture**: Fact & Dimension separation for analytical performance  
- **Semantic Modeling**: Business logic encapsulated in modular SQL views across four tracks: Growth, Customer Behavior, Product Intelligence, and Operations/Seller Performance.  
- **Automated Auditing**: Data quality checks for integrity and sanity  
- **BI Consumption**: SQL-first design powering Power BI dashboards  

---

## Business Problem Framing (The “Why”)

The analysis is framed around **four strategic business pillars**, mirroring real organizational needs:

1. **Growth & Revenue Momentum**
   - How is revenue trending month-over-month?
   - Is growth driven by order volume or basket size?

2. **Customer Behavior**
   - How many customers are repeat vs first-time?
   - Who are the top revenue-contributing customers?

3. **Marketplace & Product Intelligence**
   - Which categories and sellers drive revenue?
   - Is revenue concentrated or diversified?

4. **Geographic & Operational Intelligence**
   - Where are customers vs sellers located?
   - Are delivery delays impacting customer experience?

---

## Schema Architecture & Data Grain

Correct analytics begins with **grain awareness** to prevent over-counting.

### Core Fact Tables
- `order_items` → **Item-level grain (revenue truth)**
- `payments` → **Transaction grain**
- `reviews` → **Order-level satisfaction signals**

### Dimension Tables
- `customers`
- `products`
- `sellers`
- `geolocation`

✔ Explicit 1:N relationships enforced  
✔ Revenue always derived from **item-level data**, never order headers  

---

## Data Engineering & Defensive Cleaning

Raw data is treated as **untrusted input**.

Key logic implemented in staging and transformation layers:

- **Text Standardization**
  - `TRIM()` and `LOWER()` on categorical fields
- **Temporal Integrity**
  - Converted string timestamps to `TIMESTAMP`
  - Removed illogical records (e.g., delivery before purchase)
- **Business Logic**
  - Financial KPIs calculated only for `order_status = 'delivered'`
  - Canceled orders retained separately for operational analysis

---

## Modular SQL Modeling (Semantic Layer)

All business logic lives in **SQL views**, ensuring a **tool-agnostic Single Source of Truth**.

### Key Analytical Views

| Theme | Views | Business Purpose |
|-----|------|------------------|
| Growth | `vw_monthly_revenue`, `vw_monthly_aov` | Revenue & basket trends |
| Customers | `vw_orders_per_customer`, `vw_top_customers` | Loyalty & VIP detection |
| Marketplace | `vw_revenue_by_category`, `vw_seller_performance` | Category & seller ROI |
| Operations | `vw_delivery_delay` | SLA & logistics analysis |
| Geography | Customer vs Seller state views | Supply–demand mismatch |

These views power the BI dashboards with **minimal DAX logic**.

---

## Data Quality & Validation

To ensure trust in insights, a dedicated audit script was built.

**`08_data_quality_checks.sql` validates:**
- Primary key uniqueness  
- Referential integrity (orphan records)  
- Revenue sanity (negative or zero values)  
- Logical date sequencing  

This mirrors **real production-grade data reliability checks**.

---

## Business Intelligence Layer (Dashboards)

Due to BI tool constraints, dashboards use **sampled datasets (200 rows)**.  
However, **all SQL logic is production-scale and reusable**.

### Dashboard 1 — Business Growth & Customer Intelligence  
**Audience:** Leadership  
- Revenue, Orders, AOV, Active Customers  
- Monthly & quarterly trends  
- Demand-side geographic analysis  

### Dashboard 2 — Marketplace Performance & Operations Performance  
**Audience:** Commercial & Ops teams  
- Category revenue concentration  
- Seller performance by state  
- Orders vs revenue comparison  
- Delivery delay metrics  

### Dashboard 3 — Market Geography & Footprint   
**Audience:** Expansion & Logistics teams  
- Orders by state (demand volume)  
- Revenue by state (monetary impact)  
- Customer revenue concentration  
- Seller distribution (supply-side)  

---

## Key Engineering Insights Uncovered

- **SLA Impact:**  
  8.11% of orders breached delivery estimates, correlating with a **22% drop in average review scores**.

- **Revenue Mix Shift:**  
  Revenue growth was driven by higher-ticket categories, not order volume.

- **Data Integrity Gaps:**  
  Audit scripts identified a **0.5% orphan rate** in reviews.

- **Geolocation Deduplication:**  
  Window-function deduping prevented a potential **15% inflation** in regional metrics.

---

## Trade-Offs & Strategic Reflections

- **Views vs Materialization**  
  Views offer flexibility; in production, these would be migrated to materialized views or dbt models.

- **Dataset Constraints**  
  Lack of marketing spend (CAC) and refunds limits Net Profit and LTV analysis.

---

## Final Note

This project reflects **analytics engineering maturity**, not just SQL proficiency—  
from raw ingestion to executive-level decision intelligence.

---

## Repository Structure
```text
ecommerce_project/
├── sql/                          # Modular SQL Transformation Pipeline (01-08)
├── data/                         # Performance-optimized sample CSVs for replication
├── kpis/                         # Exported CSV result sets from SQL Views
├── dashboards/                  
│   ├── dashboards_overview.md       # Technical Case Study & Deep Dive
│   └── dashboard_screenshots/
│       ├── Growth&Customer_Insights.png
│       ├── Marketplace&Category_Analysis.png
│       └── Geographic_Intelligence.png
├── .gitignore                    # Git hygiene (prevents system clutter)
└── README.md                     # Executive Summary & Architecture




