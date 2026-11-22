-- 12_export_for_excel.sql
-- The clean data the Excel dashboard is built from. Run, then download the result as CSV.
SELECT *
FROM orders_clean
ORDER BY row_id;
