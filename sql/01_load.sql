-- 01_load.sql
-- Creates the two tables and loads the CSVs into them.
-- The CSVs sit in C:\Users\Public\superstore so the PostgreSQL service can read them.
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS returns;
CREATE TABLE orders (
    row_id         INT PRIMARY KEY,
    order_id       TEXT,
    order_date     DATE,
    ship_date      DATE,
    ship_mode      TEXT,
    customer_id    TEXT,
    customer_name  TEXT,
    segment        TEXT,
    country        TEXT,
    city           TEXT,
    state          TEXT,
    postal_code    TEXT,
    region         TEXT,
    product_id     TEXT,
    category       TEXT,
    sub_category   TEXT,
    product_name   TEXT,
    sales          NUMERIC,
    quantity       INT,
    discount       NUMERIC,
    profit         NUMERIC
);
CREATE TABLE returns (
    returned  TEXT,
    order_id  TEXT
);
-- The file writes dates as month/day/year (US style), so tell Postgres that.
SET datestyle = 'ISO, MDY';
COPY orders  FROM 'C:/Users/Public/superstore/superstore_orders.csv'  WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY returns FROM 'C:/Users/Public/superstore/superstore_returns.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
-- Quick check: should say 9994 and 296
SELECT (SELECT COUNT(*) FROM orders)  AS order_rows,
       (SELECT COUNT(*) FROM returns) AS return_rows;
