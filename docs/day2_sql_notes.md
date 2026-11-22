# Day 2 - SQL notes (PostgreSQL)

## What I did
1. Loaded the orders CSV (9,994 rows) and a Returns table (296 returned orders) into Postgres.
2. Ran a data-quality check (02_data_quality.sql).
3. Built one clean view, `orders_clean`, for the dashboard (03_clean_view.sql).
4. Calculated the KPIs and breakdowns (04 to 11).

## Data quality findings
| Check | Result |
|---|---|
| Missing values in key columns | 0 |
| Duplicate rows | 1 (order US-2014-150119, same chair twice) |
| Rows vs orders | 9,994 rows but 5,009 orders, so Orders must use COUNT(DISTINCT order_id) |
| Customers / products | 793 / 1,862 |
| Date range | 2014-01-03 to 2017-12-30 |
| Shipped before ordered | 0 |
| Zero or negative sales | 0 |
| Loss-making rows | 1,871 (19% of rows) |
| Postal codes missing leading zero | 51 (fixed with LPAD in the view) |
| Returns with no matching order | 0 |

## The 5 KPIs (2014-2017)
| KPI | Value |
|---|---|
| Total Revenue | $2,297,201 |
| Orders | 5,009 |
| Avg Order Value | $458.61 |
| Profit Margin | 12.5% |
| Return Rate | 5.9% |

Revenue and margin match the Excel pivots from Day 1.

## Growth by year
| Year | Revenue | Orders | AOV | Margin | Growth |
|---|---|---|---|---|---|
| 2014 | $484K | 969 | $500 | 10.2% | - |
| 2015 | $471K | 1,038 | $453 | 13.1% | -2.8% |
| 2016 | $609K | 1,315 | $463 | 13.4% | +29.5% |
| 2017 | $733K | 1,687 | $435 | 12.7% | +20.4% |

Growth comes from more orders; average basket size is shrinking.

## Region, 2016 vs 2017
| Region | 2017 revenue | YoY | Margin |
|---|---|---|---|
| West | $250K | +33.4% | 14.9% |
| South | $123K | +31.3% | 11.9% |
| East | $213K | +17.9% | 13.5% |
| Central | $147K | -0.2% | 7.9% |

## Discount vs profit
| Discount | Revenue | Profit | Margin |
|---|---|---|---|
| 0% | $1,088K | $321K | 29.5% |
| 1-20% | $847K | $101K | 11.9% |
| 21-40% | $234K | -$36K | -15.3% |
| 41%+ | $129K | -$100K | -77.4% |

## Draft insight headlines
1. Central is the only region not growing (-0.2% YoY vs +18-33% elsewhere) and has the weakest margin (7.9%).
2. Discounts above 20% lose money on every sale: $363K of revenue produced a $135K loss.
3. Furniture brings in 32% of revenue but only 2.5% margin, versus 17% for Technology and Office Supplies.
