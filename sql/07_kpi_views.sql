-- =====================================================
-- REVENUE & CUSTOMER KPIs
-- =====================================================

-- KPI: Monthly Revenue Trend
-- Business Question: How is revenue trending month over month?
-- Used By: Finance, Leadership
CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS month,
    SUM(p.payment_value) AS monthly_revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 1;


-- KPI: Monthly Order Volume
-- Business Question: Are orders increasing or declining?
-- Used By: Ops, Growth
CREATE OR REPLACE VIEW vw_monthly_orders AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY 1
ORDER BY 1;


-- KPI: Monthly Active Customers
-- Business Question: How many unique customers transact each month?
-- Used By: Growth, Retention
CREATE OR REPLACE VIEW vw_monthly_active_customers AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS month,
    COUNT(DISTINCT o.customer_id) AS active_customers
FROM orders o
GROUP BY 1
ORDER BY 1;


-- KPI: Quarterly Revenue
-- Business Question: How does revenue perform quarter over quarter?
-- Used By: Leadership, Finance
CREATE OR REPLACE VIEW vw_quarterly_revenue AS
SELECT
    DATE_TRUNC('quarter', o.order_purchase_timestamp::timestamp) AS quarter,
    SUM(p.payment_value) AS quarterly_revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 1;


-- KPI: Orders per Customer
-- Business Question: How engaged are customers?
-- Used By: Growth, CRM, Retention
CREATE OR REPLACE VIEW vw_orders_per_customer AS
SELECT
    o.customer_id,
    COUNT(o.order_id) AS total_orders
FROM orders o
GROUP BY o.customer_id;


-- =====================================================
-- SELLER & PRODUCT KPIs
-- =====================================================

-- KPI: Seller Performance Metrics
-- Business Question: Which sellers drive the most revenue and orders?
-- Used By: Marketplace Ops, Seller Success, Leadership
CREATE OR REPLACE VIEW vw_seller_performance AS
SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC;


-- KPI: Seller Geographic Distribution
-- Business Question: Where are sellers located?
-- Used By: Operations, Marketplace Expansion
CREATE OR REPLACE VIEW vw_seller_geo_distribution AS
SELECT
    seller_state,
    seller_city,
    COUNT(DISTINCT seller_id) AS seller_count
FROM sellers
GROUP BY seller_state, seller_city
ORDER BY seller_count DESC;


-- KPI: Product Performance Metrics
-- Business Question: Which products generate the most revenue and orders?
-- Used By: Product Strategy, Merchandising, Revenue
CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    oi.product_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY total_revenue DESC;


-- =====================================================
-- ORDERS & OPERATIONAL KPIs
-- =====================================================

-- KPI: Monthly Average Order Value (AOV)
-- Business Question: Are customers spending more or less per order?
-- Used By: Revenue, Growth, Finance, Leadership
CREATE OR REPLACE VIEW vw_monthly_aov AS
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS month,
    SUM(p.payment_value) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 1;


-- KPI: Order Delivery Delay
-- Business Question: How often are orders delivered late?
-- Used By: Operations, Customer Support, Risk
CREATE OR REPLACE VIEW vw_delivery_delay AS
SELECT
    COUNT(*) AS delayed_orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM orders
         WHERE order_delivered_customer_date <> ''
           AND order_estimated_delivery_date <> ''),
        2
    ) AS delayed_order_percentage
FROM orders
WHERE order_delivered_customer_date <> ''
  AND order_estimated_delivery_date <> ''
  AND order_delivered_customer_date::timestamp >
      order_estimated_delivery_date::timestamp;


-- KPI: Orders by Customer State
-- Business Question: Which regions generate the most orders and revenue?
-- Used By: Operations, Logistics, Regional Strategy
CREATE OR REPLACE VIEW vw_orders_by_customer_state AS
SELECT
    g.geolocation_state AS customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN geolocation_clean g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix::int
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY g.geolocation_state
ORDER BY total_revenue DESC;


-- KPI: Repeat vs First-Time Customers
-- Business Question: How much business comes from repeat customers?
-- Used By: Growth, Retention, Leadership
CREATE OR REPLACE VIEW vw_repeat_vs_first_time_customers AS
SELECT
    customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(order_id) > 1 THEN 'Repeat Customer'
            ELSE 'First-Time Customer'
        END AS customer_type
    FROM orders
    GROUP BY customer_id
) sub
GROUP BY customer_type;
