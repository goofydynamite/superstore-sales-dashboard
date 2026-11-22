-- 04_kpi_headline.sql
-- 1. The 5 headline KPIs (all 4 years)
SELECT
    ROUND(SUM(sales), 0)                                         AS total_revenue,
    COUNT(DISTINCT order_id)                                     AS orders,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2)              AS avg_order_value,
    ROUND(100 * SUM(profit) / SUM(sales), 1)                     AS profit_margin_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_returned = 1 THEN order_id END)
                / COUNT(DISTINCT order_id), 1)                   AS return_rate_pct
FROM orders_clean;
