-- 06_region_yoy.sql
-- Region revenue, 2016 vs 2017
SELECT region,
       ROUND(SUM(CASE WHEN order_year = 2016 THEN sales END), 0) AS revenue_2016,
       ROUND(SUM(CASE WHEN order_year = 2017 THEN sales END), 0) AS revenue_2017,
       ROUND(100 * (SUM(CASE WHEN order_year = 2017 THEN sales END)
                  - SUM(CASE WHEN order_year = 2016 THEN sales END))
                  / SUM(CASE WHEN order_year = 2016 THEN sales END), 1) AS yoy_growth_pct,
       ROUND(100 * SUM(profit) / SUM(sales), 1) AS margin_pct_all_years
FROM orders_clean
GROUP BY region
ORDER BY yoy_growth_pct DESC;
