# Superstore sales dashboard

The question I wanted to answer: which products and regions are driving growth, and which ones are slipping?

I used the Kaggle Superstore dataset (US orders, 2014 to 2017). I loaded and cleaned it in PostgreSQL, then built the dashboard in Excel.

![Dashboard](docs/dashboard.png)

## Findings

1. Central is the only region that didn't grow in 2017 (-0.2%, while the others grew 18-33%). Its margin also dropped from 13.5% to 5.1% that year.
2. Discounts over 20% lose money. Those sales made $363K in revenue and lost $135K. At 41% and above, the store loses about 77 cents on every dollar.
3. Furniture is almost a third of revenue but only makes a 2.5% margin. Technology and Office Supplies both make around 17%.

## Numbers

| KPI | 2014-2017 | 2017 vs 2016 |
|---|---|---|
| Revenue | $2.30M | +20.4% |
| Orders | 5,009 | +28.3% |
| Avg order value | $459 | -6.2% |
| Profit margin | 12.5% | -0.7 pts |
| Return rate | 5.9% | +0.4 pts |

Revenue went up because there were more orders. The average order actually got smaller.

## Data preparation

Here's every step from the raw file to the data the dashboard uses.

### 1. Getting the files ready

1. Downloaded `Sample - Superstore.csv` from Kaggle: 9,994 rows and 21 columns, one row per product line in an order.
2. The file is saved in Latin-1 encoding, not UTF-8, so some characters came out garbled. I re-saved it as UTF-8 (`data/raw/superstore_orders.csv`).
3. The Kaggle version has no returns data, so I couldn't calculate a return rate from it. The original Superstore Excel file has a Returns sheet with 296 returned orders, so I exported that sheet to `data/raw/superstore_returns.csv` (columns: `returned`, `order_id`).
4. I copied both CSVs to `C:\Users\Public\superstore\`, because the PostgreSQL service can't read files in my Downloads folder.

### 2. First look in Excel

5. Opened the CSV in Excel with Power Query to get a feel for it: 9,994 rows, 4 regions, 3 categories, orders from 3 Jan 2014 to 30 Dec 2017.
6. `MIN(Order Date)` returned 0, which showed that Order Date and Ship Date had loaded as text, not dates. The file writes dates as month/day/year (US style) and my PC uses day/month/year, so Excel couldn't read them. I fixed this in Power Query with Change Type > Using Locale > English (United States).
7. Made a couple of quick pivots by region and category to check the totals ($2,297,201 revenue, $286,398 profit) and spot early patterns. Furniture's 2.5% margin showed up here first.

### 3. Loading into PostgreSQL (`sql/01_load.sql`)

8. Created an `orders` table with proper types: `DATE` for the two dates, `NUMERIC` for sales, discount and profit, `INT` for quantity and row ID, and `TEXT` for everything else. Postal code is `TEXT` on purpose, since it's an ID, not a number.
9. Created a `returns` table (`returned`, `order_id`).
10. Ran `SET datestyle = 'ISO, MDY'` so Postgres reads the dates as month/day/year. This is the same date problem as in Excel.
11. Loaded both files with `COPY`. Result: 9,994 order rows and 296 return rows.

### 4. Data quality checks (`sql/02_data_quality.sql`)

| Check | Result | What I did |
|---|---|---|
| Missing values in key columns | 0 | Nothing needed |
| Exact duplicate rows | 1 (order US-2014-150119, same chair twice) | Kept it. I can't prove it's an error, and it's worth $281, so it doesn't change any result |
| Rows vs orders | 9,994 rows, 5,009 orders | Orders are counted as distinct order IDs, never as rows |
| Customers / products | 793 / 1,862 | Just for context |
| Orders shipped before they were placed | 0 | Nothing needed |
| Zero or negative sales | 0 | Nothing needed |
| Discounts outside 0-100% | 0 | Nothing needed |
| Loss-making rows | 1,871 | Real data, not an error. This led to the discount analysis |
| Postal codes missing a leading zero | 51 (e.g. 5408 instead of 05408) | Fixed in the clean view |
| Returns that don't match an order | 0 | All 296 returns join cleanly |

### 5. Clean view (`sql/03_clean_view.sql`)

12. Built one view, `orders_clean`, for all the analysis:
    - Dropped `country`, because every row is United States
    - Added `order_year` and `order_month` (first day of the month) for the trend and YoY analysis
    - Added `days_to_ship` (ship date minus order date)
    - Fixed postal codes with `LPAD(postal_code, 5, '0')`
    - Rounded sales and profit to 2 decimal places (the raw file has up to 4)
    - Added `is_returned` (1 or 0) with a `LEFT JOIN` to the returns table
    - Added `order_count`, which is 1 on the first row of each order and 0 on the rest (using `ROW_NUMBER()`). Excel pivots can't easily count distinct values, so adding up this column gives the correct number of orders. `returned_order_count` works the same way for returned orders.
13. Checked the view still has 9,994 rows, and that `order_count` adds up to 5,009 and `returned_order_count` to 296.

### 6. Analysis queries (`sql/04` to `sql/11`)

14. Calculated the 5 KPIs, KPIs by year with YoY growth, region and category growth from 2016 to 2017, the monthly trend, the top 10 products by revenue, the bottom 10 by profit, and margin by discount band.

### 7. Into Excel

15. Exported the view with `sql/12_export_for_excel.sql` to `data/clean/orders_clean.csv` (9,994 rows, 26 columns), then loaded it into Excel as a table called `orders_clean`. The dates are ISO format (YYYY-MM-DD) this time, so there was no locale problem.
16. Added two calculated columns to the table:
    - `month_name` = `TEXT(order_date, "mmm")`, so the trend chart can compare months across years
    - `discount_band` = a nested `IF` that groups discount into 0%, 1-20%, 21-40% and 41%+
17. Cross-checked the Excel totals against SQL: revenue, orders, margin and return rate all match.

### Known issue

278 product names contain non-breaking spaces (a hidden character that looks like a normal space). They don't affect any totals or rankings, so I left them. If I took this further, I'd clean them in the view with `REPLACE(product_name, CHR(160), ' ')`.

## Excel

The workbook goes Data > Pivots > Calc > Dashboard. The pivots summarise the clean data, the Calc sheet pulls the numbers out with GETPIVOTDATA, and the Dashboard sheet just displays them.

- Slicers for region, category and segment
- A dropdown that switches the trend chart between revenue, profit and orders
- Chart titles are formulas, so they update when you filter
- The arrows on the KPI cards are custom number formats

The region slicer doesn't filter the region chart, on purpose. That chart compares regions, so filtering it down to one would defeat the point.

Open `superstore_dashboard.xlsx` and start on the Dashboard tab. There's also a PDF in `docs/`.
