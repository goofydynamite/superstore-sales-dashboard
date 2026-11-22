-- 03_clean_view.sql
-- Clean view that the Excel dashboard is built from.
DROP VIEW IF EXISTS orders_clean;
CREATE VIEW orders_clean AS
SELECT
    o.row_id,
    o.order_id,
    o.order_date,
    EXTRACT(YEAR FROM o.order_date)::INT              AS order_year,
    DATE_TRUNC('month', o.order_date)::DATE           AS order_month,
    o.ship_date,
    (o.ship_date - o.order_date)                      AS days_to_ship,
    o.ship_mode,
    o.customer_id,
    o.customer_name,
    o.segment,
    o.city,
    o.state,
    LPAD(o.postal_code, 5, '0')                       AS postal_code,  -- put the lost zero back
    o.region,
    o.product_id,
    o.category,
    o.sub_category,
    o.product_name,
    ROUND(o.sales, 2)                                 AS sales,
    o.quantity,
    o.discount,
    ROUND(o.profit, 2)                                AS profit,
    CASE WHEN r.order_id IS NOT NULL THEN 1 ELSE 0 END AS is_returned,
    -- 1 on the first row of each order, 0 on the rest. Summing it in Excel = number of orders.
    CASE WHEN ROW_NUMBER() OVER (PARTITION BY o.order_id ORDER BY o.row_id) = 1
         THEN 1 ELSE 0 END                               AS order_count,
    -- Same idea, but only for returned orders. Summing it = number of returned orders.
    CASE WHEN r.order_id IS NOT NULL
          AND ROW_NUMBER() OVER (PARTITION BY o.order_id ORDER BY o.row_id) = 1
         THEN 1 ELSE 0 END                               AS returned_order_count
FROM orders o
LEFT JOIN (SELECT DISTINCT order_id FROM returns) r
       ON r.order_id = o.order_id;
-- Check: should be 9994 rows
SELECT COUNT(*) FROM orders_clean;
