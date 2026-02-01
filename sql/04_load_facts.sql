-- =====================================================
-- 04_load_facts.sql
-- Load cleaned data into fact tables
-- =====================================================

-- ======================
-- Orders fact table
-- ======================
INSERT INTO orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT DISTINCT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::TIMESTAMP,
    order_approved_at::TIMESTAMP,
    order_delivered_carrier_date::TIMESTAMP,
    order_delivered_customer_date::TIMESTAMP,
    order_estimated_delivery_date::TIMESTAMP
FROM orders_staging
WHERE order_id IS NOT NULL;

-- ======================
-- Order items fact table
-- ======================
INSERT INTO order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date::TIMESTAMP,
    price::NUMERIC,
    freight_value::NUMERIC
FROM order_items_staging
WHERE order_id IS NOT NULL;

-- ======================
-- Payments fact table
-- ======================
INSERT INTO payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value::NUMERIC
FROM payments_staging
WHERE order_id IS NOT NULL;

-- ======================
-- Reviews fact table
-- ======================
INSERT INTO reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    review_id,
    order_id,
    review_score::INT,
    review_comment_title,
    review_comment_message,
    review_creation_date::TIMESTAMP,
    review_answer_timestamp::TIMESTAMP
FROM reviews_staging
WHERE review_id IS NOT NULL;
