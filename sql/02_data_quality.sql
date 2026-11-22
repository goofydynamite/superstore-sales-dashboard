-- 02_data_quality.sql
-- Data quality checks, all in one result.
SELECT '1. Missing values (any key column)' AS check_name,
       (SELECT COUNT(*) FROM orders
        WHERE order_id IS NULL OR order_date IS NULL OR customer_id IS NULL
           OR region IS NULL OR product_id IS NULL OR sales IS NULL
           OR profit IS NULL OR postal_code IS NULL)::TEXT AS result
UNION ALL
SELECT '2. Duplicate rows (same order, product and values)',
       (SELECT COUNT(*) FROM (
            SELECT order_id, product_id, sales, quantity, discount, profit
            FROM orders
            GROUP BY order_id, product_id, sales, quantity, discount, profit
            HAVING COUNT(*) > 1) d)::TEXT
UNION ALL
SELECT '3a. Total rows',              (SELECT COUNT(*) FROM orders)::TEXT
UNION ALL
SELECT '3b. Distinct orders',         (SELECT COUNT(DISTINCT order_id) FROM orders)::TEXT
UNION ALL
SELECT '3c. Distinct customers',      (SELECT COUNT(DISTINCT customer_id) FROM orders)::TEXT
UNION ALL
SELECT '3d. Distinct products',       (SELECT COUNT(DISTINCT product_id) FROM orders)::TEXT
UNION ALL
SELECT '4a. First order date',        (SELECT MIN(order_date) FROM orders)::TEXT
UNION ALL
SELECT '4b. Last order date',         (SELECT MAX(order_date) FROM orders)::TEXT
UNION ALL
SELECT '4c. Shipped before ordered',  (SELECT COUNT(*) FROM orders WHERE ship_date < order_date)::TEXT
UNION ALL
SELECT '5a. Zero or negative sales',  (SELECT COUNT(*) FROM orders WHERE sales <= 0)::TEXT
UNION ALL
SELECT '5b. Discount outside 0-100%', (SELECT COUNT(*) FROM orders WHERE discount < 0 OR discount > 1)::TEXT
UNION ALL
SELECT '5c. Loss-making rows',        (SELECT COUNT(*) FROM orders WHERE profit < 0)::TEXT
UNION ALL
SELECT '6. Postal codes missing leading zero',
       (SELECT COUNT(DISTINCT postal_code) FROM orders WHERE LENGTH(postal_code) < 5)::TEXT
UNION ALL
SELECT '7. Returns with no matching order',
       (SELECT COUNT(*) FROM returns r
        WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.order_id = r.order_id))::TEXT;
