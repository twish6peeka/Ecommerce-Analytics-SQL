# End-to-End E-Commerce Analytics Pipeline (SQL + BI)

## Executive Overview
This project demonstrates a **production-style, end-to-end Analytics Engineering workflow**, transforming raw e-commerce transactional data into **executive-ready business intelligence**.

Built on a public e-commerce dataset (~99K orders), the focus is not ad-hoc querying, but **structured data modeling, defensive SQL engineering, and business storytelling** through dashboards.

The pipeline follows a **clear 8-step Analytics Framework**, moving from business problem framing → data modeling → data quality → semantic SQL views → BI dashboards.

---

## Tech Stack
- **Database**: PostgreSQL  
- **Data Modeling**: Modular SQL (Staging → Fact/Dimensions → Analytical Views)  
- **BI Tool**: Power BI  
- **Design Philosophy**: Single Source of Truth via SQL Views  

---

## Business Problem Framing (The “Why”)
The analysis is framed around **four strategic business pillars**, mirroring how real organizations think:

1. **Growth & Revenue Momentum**
   - How is revenue trending month-over-month?
   - Is growth driven by orders or basket size?

2. **Customer Behavior**
   - How many customers are repeat vs first-time?
   - Who are the top revenue-contributing customers?

3. **Marketplace & Product Intelligence**
   - Which product categories and sellers drive revenue?
   - Is revenue concentrated or diversified?

4. **Geographic & Operational Intelligence**
   - Where are customers vs sellers located?
   - Are delivery delays impacting customer experience?

---

## Schema Architecture & Data Grain
Correct analytics starts with **grain awareness** to prevent over-counting.

### Core Fact Tables
- `order_items` → **Item-level grain** (revenue truth)
- `payments` → **Transaction grain**
- `reviews` → **Order-level satisfaction signals**

### Dimension Tables
- `customers`
- `products`
- `sellers`
- `geolocation`

✔ Explicit 1:N relationships were enforced  
✔ Revenue calculations are always derived from **item-level data**, not orders  

---

## Data Engineering & Defensive Cleaning
Raw data is treated as **untrusted input**.

Key cleaning logic implemented in staging and transformation scripts:

- **Text Standardization**
  - `TRIM()` and `LOWER()` on categorical fields
- **Temporal Integrity**
  - Converted string timestamps to `TIMESTAMP`
  - Removed illogical records (e.g. delivery before purchase)
- **Business Logic**
  - Financial KPIs calculated only for `order_status = 'delivered'`
  - Canceled orders retained separately for operational analysis

---

## Modular SQL Modeling (Semantic Layer)
All business logic lives in SQL views to ensure a **tool-agnostic Single Source of Truth**.

### Key Analytical Views
| Theme | Views | Business Purpose |
|-----|------|------------------|
| Growth | `vw_monthly_revenue`, `vw_monthly_aov` | Revenue & basket trends |
| Customers | `vw_orders_per_customer`, `vw_top_customers` | Loyalty & VIP detection |
| Marketplace | `vw_revenue_by_category`, `vw_seller_performance` | Category & seller ROI |
| Operations | `vw_delivery_delay` | Logistics & SLA analysis |
| Geography | Customer vs Seller state views | Supply–demand mismatch |

These views directly power the BI dashboards with **minimal DAX logic**.

---

## Data Quality & Validation
To ensure trust in insights, a dedicated audit script was built:

**`08_data_quality_checks.sql` validates:**
- Primary key uniqueness
- Referential integrity (orphan records)
- Revenue sanity (negative or zero values)
- Logical date sequencing

This simulates real-world **data reliability checks** used in production pipelines.

---

## Business Intelligence Layer (Dashboards)
The BI layer is structured for **three stakeholder personas**:

### Dashboard 1 — Growth & Customer Insights
**Audience:** Leadership  
- Revenue, Orders, AOV KPI cards  
- Monthly trends (Orders vs Revenue gap)
- Customer distribution by geography  

---

### Dashboard 2 — Marketplace & Category Performance
**Audience:** Commercial & Ops teams  
- Revenue by product category  
- Seller concentration by state  
- Top sellers and category dominance  

---

### Dashboard 3 — Geographic Intelligence
**Audience:** Expansion & Logistics teams  
- Customer vs Seller heatmaps  
- Regional demand–supply imbalance  
- Strategic expansion signals  

---

## Trade-Offs & Strategic Reflections
- **Views vs Materialization**  
  Views provide flexibility; for large-scale production, these would be migrated to materialized views or dbt models.

- **Dataset Constraints**  
  Lack of marketing spend and refund data limits Net Profit and LTV analysis.

---

## Repository Structure
ecommerce_project/
├── sql/
│   ├── 01_schema.sql                # DDL & Star Schema setup
│   ├── 02_staging.sql               # Raw data landing zone
│   ├── 03_data_cleaning.sql          # Defensive cleaning (TRIM, NULLs)
│   ├── 04_load_facts.sql             # Fact table population & casting
│   ├── 05_load_dimensions.sql        # Dimension population & deduplication
│   ├── 06_views.sql                 # Base analytical layer
│   ├── 07_kpi_views.sql             # Advanced business logic (26 views)
│   └── 08_data_quality_checks.sql    # Audit suite & referential integrity
├── data/                            # Performance-optimized sample CSVs
├── kpis/                            # Sample CSV outputs of SQL Views
├── docs/
│   ├── project_overview.md          # Technical Deep Dive
│   └── dashboard_screenshots/       # GROWTH, MARKETPLACE, & GEO visuals
└── README.md                        # Portfolio Summary

