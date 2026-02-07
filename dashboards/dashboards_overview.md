# Dashboard Insights & Stakeholder Logic  
*(BI Layer Documentation)*

This document explains the **business logic, stakeholder intent, and strategic insights** behind the three Business Intelligence dashboards included in this project.

All visuals are powered directly by the **SQL Semantic Layer** (`sql/07_kpi_views.sql`), ensuring a **Single Source of Truth (SSOT)** and eliminating logic duplication inside the BI tool.

---

## Dashboard Design Philosophy

These dashboards were intentionally designed to be:

- **Persona-driven**  
  Each dashboard serves a clearly defined business audience.

- **Decision-oriented**  
  Focused on “What action should we take next?” rather than exploratory clutter.

- **SQL-powered**  
  All heavy logic (aggregations, flags, SLA math) is handled in PostgreSQL.

- **Tool-agnostic & scalable**  
  Dashboards can be migrated to Tableau or Looker without rewriting business logic.

This reflects a **modern Analytics Engineering approach** where BI is a thin visualization layer on top of a strong data model.

---

## Requirements & Acceptance Criteria (Applied to Dashboards)

### Business Requirement
Enable leadership and operations teams to monitor growth, operational risk, and market gaps from a unified system.

### Acceptance Criteria Example
**Delivery Performance Audit**
- **Given** an order is delivered  
- **When** actual delivery exceeds estimated delivery  
- **Then** the dashboard reflects an SLA breach and supports correlation with review scores

This logic is implemented in `vw_delivery_delay`.

---

## Dashboard 1: Business Growth & Customer Intelligence

**Primary Stakeholders:**  
CEO, Chief Revenue Officer (CRO), Executive Leadership  

**Business Objective:**  
Monitor top-line financial health, revenue momentum, and customer acquisition quality.

### Key Visuals & Business Logic

### Executive KPI Ribbon
- **Metrics:** Total Revenue, Total Orders, Average Order Value (AOV), Monthly Active Customers
- **SQL Logic:**  
  KPIs are calculated **only from delivered orders** to ensure financial accuracy and avoid revenue inflation.

**Why it matters:**  
Provides a <5 second health check for leadership.

---

### Revenue vs Orders Trend (Dual Axis)
- **Purpose:** Evaluate the *quality of growth*
- **Insight Logic:**  
  - Revenue ↑ while Orders → flat  
    → Growth driven by higher-ticket products or increased basket size  
  - Orders ↑ but Revenue → flat  
    → Possible discounting or low-margin growth

This helps leadership distinguish **scalable growth** from **volume-only growth**.

---

### Customer Demand by Geography
- Visualizes where customers are concentrated
- Supports regional prioritization and demand forecasting

---

## Dashboard 2: Marketplace & Operations Performance

**Primary Stakeholders:**  
Commercial Director, Category Managers, Operations Teams  

**Business Objective:**  
Optimize product mix, monitor seller performance, and identify revenue concentration risks.

### Key Visuals & Business Logic

### Category Revenue Treemap
- Instantly highlights **“Power Categories”**
- Reveals over-dependence on a small number of categories

**Strategic Value:**  
Supports diversification decisions and category investment planning.

---

### Seller Performance by State
- Identifies regional seller hubs
- Highlights concentration risk on specific states

**Insight:**  
Over-reliance on a single seller region can expose the business to operational or regulatory risk.

---

### Volume vs Value Comparison
- Compares **order volume** against **revenue contribution**

**Business Interpretation:**
- High volume + low revenue → *Loss Leaders*
- Low volume + high revenue → *Profit Drivers*

Used by commercial teams to guide pricing, promotions, and assortment strategy.

---

## Dashboard 3: Market Geography & Footprint (Maps)

**Primary Stakeholders:**  
Head of Logistics, Expansion Strategy Team  

**Business Objective:**  
Identify supply–demand mismatches and logistics bottlenecks.

### Key Visuals & Business Logic

### Demand Density Map
- Shows customer order concentration by state
- Highlights high-demand regions

---

### Customer vs Seller Distribution
- Compares **where customers live** vs **where sellers operate**

**Strategic Use Case:**  
States with high demand but low seller presence are flagged for:
- Targeted seller onboarding
- Reduced shipping distances
- Improved delivery speed

---

### Logistics SLA Heatmap
- Visualizes regions with the highest **Delivery Gaps**  
  *(Actual vs Estimated delivery)*

**Key Finding:**  
Regions with higher delivery delays directly correlate with a **22% drop in average review scores**, as identified in the SQL audit layer.

---

## Traceability: SQL → Dashboard

| Dashboard Visual | SQL View | Business Rule |
|-----------------|----------|---------------|
| Monthly Revenue | `vw_monthly_revenue` | Delivered orders only |
| Loyalty Split | `vw_orders_per_customer` | Window functions |
| SLA Map | `vw_delivery_delay` | Actual vs estimated |

---

## Strategic Reflection: “Thin” Dashboard Architecture

A core technical highlight of this project is its **decoupled analytics architecture**.

- **Zero Heavy DAX**  
  No complex calculated columns or measures in the BI layer.

- **SQL-First Logic**  
  All KPIs, SLA metrics, and aggregations are defined in PostgreSQL.

- **Consistency Across Teams**  
  Finance, Operations, and Leadership always see the same numbers.

- **Performance & Maintainability**  
  Dashboards load faster and are easier to scale or migrate across tools.

---

## Summary

These dashboards demonstrate how **well-modeled SQL**, combined with **intentional BI design**, enables faster decisions, clearer insights, and scalable analytics systems.

These dashboards are not just visuals, they are **decision systems** built on:
- Clear requirements
- Explicit business rules
- Auditable SQL logic
- Stakeholder-aligned design
