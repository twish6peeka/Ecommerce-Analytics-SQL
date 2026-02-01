-- =========================
-- 08_data_quality_checks.sql
-- Comprehensive Data Quality Checks
-- =========================

-- =========================
-- Customers Table
-- =========================
SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS null_customer_ids
FROM customers
WHERE customer_id IS NULL OR customer_id = '';

SELECT COUNT(DISTINCT customer_id) AS unique_customer_ids FROM customers;

-- Sample data
SELECT * FROM customers LIMIT 20;

-- =========================
-- Products Table
-- =========================
SELECT COUNT(*) AS total_products FROM products;

SELECT COUNT(*) AS null_product_ids
FROM products
WHERE product_id IS NULL;

SELECT COUNT(DISTINCT product_id) AS unique_product_ids FROM products;

-- Sample data
SELECT * FROM products LIMIT 20;

-- =========================
-- Product Categories
-- =========================
SELECT COUNT(*) AS total_product_categories FROM product_categories;

-- Sample data
SELECT * FROM product_categories LIMIT 20;

-- =========================
-- Sellers Table
-- =========================
SELECT COUNT(*) AS total_sellers FROM sellers;

SELECT COUNT(*) AS null_seller_ids
FROM sellers
WHERE seller_id IS NULL;

SELECT COUNT(DISTINCT seller_id) AS unique_sellers FROM sellers;

-- Sample data
SELECT * FROM sellers LIMIT 20;

-- =========================
-- Geolocation Table
-- =========================
SELECT COUNT(*) AS total_geolocation_clean FROM geolocation_clean;

SELECT COUNT(*) AS null_zip_codes
FROM geolocation_clean
WHERE geolocation_zip_code_prefix IS NULL;

-- Sample data
SELECT * FROM geolocation_clean LIMIT 20;

-- =========================
-- Orders Table
-- =========================
SELECT COUNT(*) AS total_orders FROM orders;

SELECT COUNT(*) AS orders_with_invalid_customer
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(DISTINCT order_id) AS unique_orders FROM orders;

-- Sample data
SELECT * FROM orders LIMIT 20;

-- =========================
-- Order Items Table
-- =========================
SELECT COUNT(*) AS total_order_items FROM order_items;

SELECT COUNT(*) AS duplicate_order_items
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

SELECT COUNT(DISTINCT order_item_id) AS unique_order_items FROM order_items;

-- Sample data
SELECT * FROM order_items LIMIT 20;

-- =========================
-- Payments Table
-- =========================
SELECT COUNT(*) AS total_payments FROM payments;

SELECT COUNT(*) AS orphan_payments
FROM payments p
LEFT JOIN orders o ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(DISTINCT payment_id) AS unique_payments FROM payments;

-- Sample data
SELECT * FROM payments LIMIT 20;

-- =========================
-- Reviews Table
-- =========================
SELECT COUNT(*) AS total_reviews FROM reviews;

SELECT COUNT(*) AS orphan_reviews
FROM reviews r
LEFT JOIN orders o ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(DISTINCT review_id) AS unique_reviews FROM reviews;

-- Sample data
SELECT * FROM reviews LIMIT 20;

-- =========================
-- Analytical Views Sample Checks
-- =========================
-- This ensures views return expected results
SELECT * FROM customer_orders_summary LIMIT 20;
SELECT * FROM orders_by_category LIMIT 20;
SELECT * FROM orders_by_city LIMIT 20;
SELECT * FROM orders_by_region LIMIT 20;
SELECT * FROM orders_by_seller_state LIMIT 20;
SELECT * FROM orders_by_state LIMIT 20;
SELECT * FROM product_performance LIMIT 20;
SELECT * FROM revenue_by_category LIMIT 20;
SELECT * FROM revenue_by_customer_location LIMIT 20;
SELECT * FROM revenue_by_seller LIMIT 20;
SELECT * FROM seller_performance LIMIT 20;
SELECT * FROM top_customers LIMIT 20;
SELECT * FROM vw_delivery_delay LIMIT 20;
SELECT * FROM vw_monthly_active_customers LIMIT 50;
SELECT * FROM vw_monthly_aov LIMIT 50;
SELECT * FROM vw_monthly_order_volume LIMIT 50;
SELECT * FROM vw_monthly_orders LIMIT 50;
SELECT * FROM vw_monthly_revenue LIMIT 50;
SELECT * FROM vw_orders_by_customer_state LIMIT 50;
SELECT * FROM vw_orders_per_customer LIMIT 50;
SELECT * FROM vw_product_performance LIMIT 50;
SELECT * FROM vw_quarterly_revenue LIMIT 50;
SELECT * FROM vw_repeat_vs_first_time_customers LIMIT 50;
SELECT * FROM vw_seller_geo_distribution LIMIT 50;
SELECT * FROM vw_seller_performance LIMIT 50;
