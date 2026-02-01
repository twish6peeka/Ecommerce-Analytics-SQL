-- =====================================================
-- 05_load_dimensions.sql
-- Populate dimension tables from cleaned staging data
-- =====================================================

-- =========================
-- Customers Dimension
-- =========================
INSERT INTO customers (
    customer_id,
    full_name,
    email,
    signup_date,
    country,
    customer_zip_code_prefix
)
SELECT DISTINCT
    TRIM(customer_id),
    TRIM(full_name),
    LOWER(TRIM(email)),
    signup_date::DATE,
    TRIM(country),
    customer_zip_code_prefix
FROM customers_staging
WHERE customer_id IS NOT NULL
  AND customer_id <> '';


-- =========================
-- Products Dimension
-- =========================
INSERT INTO products (
    product_id,
    product_name,
    product_category_name,
    price,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT DISTINCT
    product_id,
    product_name,
    product_category_name,
    price::NUMERIC,
    product_name_length::INT,
    product_description_length::INT,
    product_photos_qty::INT,
    product_weight_g::NUMERIC,
    product_length_cm::NUMERIC,
    product_height_cm::NUMERIC,
    product_width_cm::NUMERIC
FROM products_staging
WHERE product_id IS NOT NULL
  AND product_id <> '';


-- =========================
-- Sellers Dimension
-- =========================
INSERT INTO sellers (
    seller_id,
    seller_name,
    seller_city,
    seller_state,
    seller_zip_code,
    seller_country
)
SELECT DISTINCT
    seller_id,
    seller_name,
    seller_city,
    seller_state,
    seller_zip_code,
    seller_country
FROM sellers_staging
WHERE seller_id IS NOT NULL
  AND seller_id <> '';


-- =========================
-- Geolocation Dimension
-- =========================
INSERT INTO geolocation_clean (
    geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state
)
SELECT DISTINCT
    geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state
FROM geolocation_staging
WHERE geolocation_zip_code_prefix IS NOT NULL
  AND geolocation_zip_code_prefix <> '';


-- =========================
-- Product Category Translation (Lookup Dimension)
-- =========================
INSERT INTO product_category_translation (
    product_category_name,
    product_category_name_english
)
SELECT DISTINCT
    product_category_name,
    product_category_name_english
FROM product_category_translation
WHERE product_category_name IS NOT NULL;
