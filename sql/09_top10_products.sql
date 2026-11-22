-- 09_top10_products.sql
-- Top 10 products by revenue
SELECT product_name,
       category,
       ROUND(SUM(sales), 0)                     AS revenue,
       ROUND(SUM(profit), 0)                    AS profit,
       ROUND(100 * SUM(profit) / SUM(sales), 1) AS margin_pct
FROM orders_clean
GROUP BY product_name, category
ORDER BY SUM(sales) DESC
LIMIT 10;
