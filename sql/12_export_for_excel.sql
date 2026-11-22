-- 12_export_for_excel.sql
-- Clean data for Excel. I saved the result as data/clean/orders_clean.csv.
SELECT *
FROM orders_clean
ORDER BY row_id;
