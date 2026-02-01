-- =====================================================
-- 01_schema.sql
-- Core warehouse schema (final state)
-- =====================================================

-- ======================
-- Customers Dimension Table
-- ======================
CREATE TABLE IF NOT EXISTS customers (
    customer_id TEXT PRIMARY KEY,
    full_name TEXT,
    email TEXT,
    signup_date DATE,
    country TEXT,
    customer_zip_code_prefix TEXT
);

-- ======================
-- Products Dimension Table
-- ======================
CREATE TABLE IF NOT EXISTS products (
    product_id TEXT PRIMARY KEY,
    product_name TEXT,
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

-- ======================
-- Sellers Dimension Table
-- ======================
CREATE TABLE IF NOT EXISTS sellers (
    seller_id TEXT PRIMARY KEY,
    seller_name TEXT,
    seller_city TEXT,
    seller_state TEXT,
    seller_zip_code TEXT,
    seller_country TEXT
);

-- ======================
-- Orders Dimension Table
-- ======================
CREATE TABLE IF NOT EXISTS orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ========================
-- Order Items Fact Table
-- ========================
CREATE TABLE IF NOT EXISTS order_items (
    order_id TEXT,
    order_item_id INT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC,
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

-- ======================
-- Payments Fact Table
-- ======================
CREATE TABLE IF NOT EXISTS payments (
    order_id TEXT,
    payment_sequential INT,
    payment_type TEXT,
    payment_installments INT,
    payment_value NUMERIC,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ======================
-- Reviews Fact Table
-- ======================
CREATE TABLE IF NOT EXISTS reviews (
    review_id TEXT PRIMARY KEY,
    order_id TEXT,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- =============================================================
-- Product Category Translation Dimension Table
-- =============================================================
CREATE TABLE IF NOT EXISTS product_category_translation (
    product_category_name TEXT PRIMARY KEY,
    product_category_name_english TEXT
);

-- ================================================
-- Geolocation (cleaned) Dimension Table
-- ================================================
CREATE TABLE IF NOT EXISTS geolocation_clean (
    geolocation_zip_code_prefix TEXT,
    geolocation_city TEXT,
    geolocation_state TEXT
);

