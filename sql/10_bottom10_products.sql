-- 10_bottom10_products.sql
-- 7. Bottom 10 products by profit (where margin is being lost)
SELECT product_name,
       category,
       ROUND(SUM(sales), 0)                     AS revenue,
       ROUND(SUM(profit), 0)                    AS profit,
       ROUND(AVG(discount) * 100, 0)            AS avg_discount_pct
FROM orders_clean
GROUP BY product_name, category
ORDER BY SUM(profit) ASC
LIMIT 10;
