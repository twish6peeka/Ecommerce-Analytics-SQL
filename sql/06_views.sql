-- =====================================================
-- 06_views.sql
-- Analytical Views 
-- Used for dashboards, exploration, and storytelling
-- =====================================================


-- =====================================================
-- Customer & Order Summary Views
-- =====================================================

-- Orders by customer state
-- Regional demand and revenue analysis
CREATE OR REPLACE VIEW orders_by_state AS
SELECT
    g.geolocation_state,
    COUNT(o.order_id) AS orders,
    SUM(p.payment_value) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN geolocation_clean g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix::INT
JOIN payments p USING (order_id)
GROUP BY g.geolocation_state
ORDER BY revenue DESC;


-- Customer-level order and spend summary
CREATE OR REPLACE VIEW customer_orders_summary AS
SELECT
    c.customer_id,
    COUNT(o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_spent,
    AVG(p.payment_value) AS avg_order_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN payments p USING (order_id)
GROUP BY c.customer_id
ORDER BY total_spent DESC;


-- =====================================================
-- Product & Category Views
-- =====================================================

-- Orders and revenue by product category (English)
CREATE OR REPLACE VIEW orders_by_category AS
SELECT
    pct.product_category_name_english AS category,
    COUNT(oi.order_id) AS total_orders,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY revenue DESC;


-- Product-level performance metrics
CREATE OR REPLACE VIEW product_performance AS
SELECT
    p.product_id,
    p.product_name,
    pct.product_category_name_english AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue,
    AVG(oi.price) AS avg_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY p.product_id, p.product_name, pct.product_category_name_english
ORDER BY total_revenue DESC;


-- =====================================================
-- Seller & Marketplace Views
-- =====================================================

-- Orders and revenue by seller state
CREATE OR REPLACE VIEW orders_by_seller_state AS
SELECT
    s.seller_state,
    COUNT(oi.order_id) AS total_orders,
    SUM(oi.price) AS revenue
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
ORDER BY revenue DESC;


-- Seller performance summary
CREATE OR REPLACE VIEW seller_performance AS
SELECT
    s.seller_id,
    s.seller_name,
    s.seller_state,
    s.seller_city,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_name, s.seller_state, s.seller_city
ORDER BY total_revenue DESC;


-- =====================================================
-- Revenue-Focused Views
-- =====================================================

-- Revenue by product category
CREATE OR REPLACE VIEW revenue_by_category AS
SELECT
    pct.product_category_name_english AS category,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation pct
    ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY total_revenue DESC;


-- Revenue by seller (geo-aware)
CREATE OR REPLACE VIEW revenue_by_seller AS
SELECT
    s.seller_id,
    s.seller_name,
    s.seller_state,
    s.seller_city,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_name, s.seller_state, s.seller_city
ORDER BY total_revenue DESC;


-- Revenue by customer location (state & city)
CREATE OR REPLACE VIEW revenue_by_customer_location AS
SELECT
    g.geolocation_state AS customer_state,
    g.geolocation_city AS customer_city,
    SUM(p.payment_value) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_id) AS unique_customers
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN geolocation_clean g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix::INT
JOIN payments p ON o.order_id = p.order_id
GROUP BY g.geolocation_state, g.geolocation_city
ORDER BY total_revenue DESC;


-- =====================================================
-- Regional & City-Level Views
-- =====================================================

-- Orders and revenue by city
CREATE OR REPLACE VIEW orders_by_city AS
SELECT
    g.geolocation_city,
    COUNT(o.order_id) AS total_orders,
    SUM(p.payment_value) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN geolocation_clean g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix::INT
JOIN payments p USING (order_id)
GROUP BY g.geolocation_city
ORDER BY revenue DESC;


-- Regional (state-level) logistics view
CREATE OR REPLACE VIEW orders_by_region AS
SELECT
    g.geolocation_state AS customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN geolocation_clean g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix::INT
JOIN payments p ON o.order_id = p.order_id
GROUP BY g.geolocation_state
ORDER BY total_revenue DESC;


-- =====================================================
-- Customer Ranking Views
-- =====================================================

-- Top customers by total spend
CREATE OR REPLACE VIEW top_customers AS
SELECT
    c.customer_id,
    SUM(p.payment_value) AS total_spent,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;
