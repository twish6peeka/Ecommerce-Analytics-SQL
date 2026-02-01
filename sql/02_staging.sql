-- ==========================================
-- 02_staging.sql
-- Temporary staging tables for cleaning
-- ==========================================

-- ======================
-- Drop staging tables (safe reset)
-- ======================
DROP TABLE IF EXISTS customers_staging;
DROP TABLE IF EXISTS orders_staging;
DROP TABLE IF EXISTS order_items_staging;
DROP TABLE IF EXISTS payments_staging;
DROP TABLE IF EXISTS reviews_staging;
DROP TABLE IF EXISTS sellers_staging;
DROP TABLE IF EXISTS geolocation_staging;
DROP TABLE IF EXISTS products_staging;

-- ======================
-- Customers staging
-- ======================
CREATE TABLE customers_staging (
    customer_id TEXT,
    full_name TEXT,
    email TEXT,
    signup_date TEXT,
    country TEXT,
    customer_zip_code_prefix TEXT
);

-- ======================
-- Orders staging
-- ======================
CREATE TABLE orders_staging (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);

-- ======================
-- Order items staging
-- ======================
CREATE TABLE order_items_staging (
    order_id TEXT,
    order_item_id INT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TEXT,
    price TEXT,
    freight_value TEXT
);

-- ======================
-- Payments staging
-- ======================
CREATE TABLE payments_staging (
    order_id TEXT,
    payment_sequential INT,
    payment_type TEXT,
    payment_installments INT,
    payment_value TEXT
);

-- ======================
-- Reviews staging
-- ======================
CREATE TABLE reviews_staging (
    review_id TEXT,
    order_id TEXT,
    review_score TEXT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT
);

-- ======================
-- Sellers staging
-- ======================
CREATE TABLE sellers_staging (
    seller_id TEXT,
    seller_name TEXT,
    seller_city TEXT,
    seller_state TEXT,
    seller_zip_code TEXT,
    seller_country TEXT
);

-- ======================
-- Products staging
-- ======================
CREATE TABLE products_staging (
    product_id TEXT,
    product_name TEXT,
    product_category_name TEXT,
    price TEXT,
    product_name_length TEXT,
    product_description_length TEXT,
    product_photos_qty TEXT,
    product_weight_g TEXT,
    product_length_cm TEXT,
    product_height_cm TEXT,
    product_width_cm TEXT
);

-- ======================
-- Geolocation staging
-- ======================
CREATE TABLE geolocation_staging (
    geolocation_zip_code_prefix TEXT,
    geolocation_city TEXT,
    geolocation_state TEXT
);
