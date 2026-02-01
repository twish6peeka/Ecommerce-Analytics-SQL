-- =====================================================
-- 01_schema.sql
-- E-Commerce Project - Database Schema
-- =====================================================

-- ===============================
-- DROP TABLES 
-- ===============================

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS sellers CASCADE;
DROP TABLE IF EXISTS geolocation_clean CASCADE;

-- ===============================
-- CREATE TABLES
-- ===============================

-- 1️ Customers Dimension Table
CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE,
    country TEXT,
    customer_zip_code_prefix TEXT
);

-- 2️ Products Dimension Table
CREATE TABLE products (
    product_id TEXT PRIMARY KEY,
    product_name VARCHAR(100),
    product_category_name TEXT,
    price NUMERIC(10,2),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

-- 3️ Orders Fact Table
CREATE TABLE orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL REFERENCES customers(customer_id),
    order_date DATE,
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- 4️ Sellers Dimension Table
CREATE TABLE sellers (
    seller_id TEXT PRIMARY KEY,
    seller_name TEXT,
    seller_city TEXT,
    seller_state TEXT,
    seller_zip_code TEXT,
    seller_country TEXT
);


-- 5️ Payments Fact Table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id TEXT NOT NULL REFERENCES orders(order_id),
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20),
    payment_installments INT,
    payment_value NUMERIC
);

-- 6️ Reviews Fact Table
CREATE TABLE reviews (
    review_id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL REFERENCES orders(order_id),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- 7️ Order Items Fact Table
CREATE TABLE order_items (
    order_id TEXT NOT NULL REFERENCES orders(order_id),
    order_item_id INT NOT NULL,
    product_id TEXT NOT NULL REFERENCES products(product_id),
    seller_id TEXT REFERENCES sellers(seller_id),
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC,
    PRIMARY KEY (order_id, order_item_id)
);

-- 8️ Geolocation Clean Dimension Table
CREATE TABLE geolocation_clean (
    geolocation_zip_code_prefix TEXT PRIMARY KEY,
    geolocation_city TEXT,
    geolocation_state TEXT
);

-- ===============================
-- Schema Setup Complete
-- ===============================
