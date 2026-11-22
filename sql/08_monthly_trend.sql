-- 08_monthly_trend.sql
-- 5. Monthly trend
SELECT order_month,
       ROUND(SUM(sales), 0)     AS revenue,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(profit), 0)    AS profit
FROM orders_clean
GROUP BY order_month
ORDER BY order_month;
