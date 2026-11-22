-- 05_kpi_by_year.sql
-- Same KPIs by year, with year-over-year revenue growth
WITH yearly AS (
    SELECT order_year,
           SUM(sales)               AS revenue,
           COUNT(DISTINCT order_id) AS orders,
           SUM(profit)              AS profit
    FROM orders_clean
    GROUP BY order_year
)
SELECT order_year,
       ROUND(revenue, 0)                    AS revenue,
       orders,
       ROUND(revenue / orders, 2)           AS avg_order_value,
       ROUND(100 * profit / revenue, 1)     AS profit_margin_pct,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY order_year))
                 / LAG(revenue) OVER (ORDER BY order_year), 1) AS revenue_growth_pct
FROM yearly
ORDER BY order_year;
