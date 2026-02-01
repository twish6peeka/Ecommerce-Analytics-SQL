-- =====================================================
-- 03_data_cleaning.sql
-- Clean & standardize data in staging tables
-- =====================================================

-- ======================
-- Customers cleaning
-- ======================
UPDATE customers_staging
SET
    customer_id = TRIM(customer_id),
    full_name = TRIM(full_name),
    email = LOWER(TRIM(email)),
    country = TRIM(country),
    customer_zip_code_prefix = TRIM(customer_zip_code_prefix);

-- Remove empty strings → NULL
UPDATE customers_staging
SET email = NULL
WHERE email = '';

-- ======================
-- Orders cleaning
-- ======================
UPDATE orders_staging
SET
    order_id = TRIM(order_id),
    customer_id = TRIM(customer_id),
    order_status = TRIM(order_status),
    order_purchase_timestamp = NULLIF(order_purchase_timestamp, ''),
    order_approved_at = NULLIF(order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(order_estimated_delivery_date, '');

-- ======================
-- Order items cleaning
-- ======================
UPDATE order_items_staging
SET
    order_id = TRIM(order_id),
    product_id = TRIM(product_id),
    seller_id = TRIM(seller_id),
    shipping_limit_date = NULLIF(shipping_limit_date, ''),
    price = NULLIF(price, ''),
    freight_value = NULLIF(freight_value, '');

-- ======================
-- Payments cleaning
-- ======================
UPDATE payments_staging
SET
    order_id = TRIM(order_id),
    payment_type = TRIM(payment_type),
    payment_value = NULLIF(payment_value, '');

-- ======================
-- Reviews cleaning
-- ======================
UPDATE reviews_staging
SET
    review_id = TRIM(review_id),
    order_id = TRIM(order_id),
    review_score = NULLIF(review_score, ''),
    review_creation_date = NULLIF(review_creation_date, ''),
    review_answer_timestamp = NULLIF(review_answer_timestamp, '');

-- ======================
-- Sellers cleaning
-- ======================
UPDATE sellers_staging
SET
    seller_id = TRIM(seller_id),
    seller_name = TRIM(seller_name),
    seller_city = TRIM(seller_city),
    seller_state = TRIM(seller_state),
    seller_zip_code = TRIM(seller_zip_code),
    seller_country = TRIM(seller_country);

-- ======================
-- Products cleaning
-- ======================
UPDATE products_staging
SET
    product_id = TRIM(product_id),
    product_name = TRIM(product_name),
    product_category_name = TRIM(product_category_name),
    price = NULLIF(price, ''),
    product_weight_g = NULLIF(product_weight_g, ''),
    product_length_cm = NULLIF(product_length_cm, ''),
    product_height_cm = NULLIF(product_height_cm, ''),
    product_width_cm = NULLIF(product_width_cm, '');

-- ======================
-- Geolocation cleaning
-- ======================
UPDATE geolocation_staging
SET
    geolocation_zip_code_prefix = TRIM(geolocation_zip_code_prefix),
    geolocation_city = TRIM(geolocation_city),
    geolocation_state = TRIM(geolocation_state);
