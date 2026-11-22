-- 11_discount_vs_profit.sql
-- Margin by discount band
SELECT CASE WHEN discount = 0    THEN '0%'
            WHEN discount <= 0.2 THEN '1-20%'
            WHEN discount <= 0.4 THEN '21-40%'
            ELSE '41%+' END                     AS discount_band,
       COUNT(*)                                 AS order_lines,
       ROUND(SUM(sales), 0)                     AS revenue,
       ROUND(SUM(profit), 0)                    AS profit,
       ROUND(100 * SUM(profit) / SUM(sales), 1) AS margin_pct
FROM orders_clean
GROUP BY 1
ORDER BY 1;
