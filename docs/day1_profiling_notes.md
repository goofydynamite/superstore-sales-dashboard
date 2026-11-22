# Day 1 - Profiling notes

## The basics
- Row count: 9,994 (one row = one product line in an order)
- Column count: 21
- Date range: 03-01-2014 to 30-12-2017 (4 full years, so YoY works)
- Regions: Central, East, South, West
- Categories: Furniture, Office Supplies, Technology
- Currency: US dollars

## Data quality issues found
- Order Date and Ship Date loaded as text, not dates. The file uses US format
  (M/D/YYYY) and my PC uses Indian format, so Excel could not read them.
  Fixed in Power Query: Change Type > Using Locale > English (United States).
- No returns column in this dataset, so Return Rate can't be calculated directly.
- Blanks and duplicate check: to do in SQL (Day 2).

## First numbers (Excel pivots)
| Region  | Sales  | Profit | Margin |
|---------|--------|--------|--------|
| West    | $725K  | $108K  | 14.9%  |
| East    | $679K  | $92K   | 13.5%  |
| Central | $501K  | $40K   | 7.9%   |
| South   | $392K  | $47K   | 11.9%  |

| Category        | Sales | Profit | Margin |
|-----------------|-------|--------|--------|
| Technology      | $836K | $145K  | 17.4%  |
| Office Supplies | $719K | $122K  | 17.0%  |
| Furniture       | $742K | $18K   | 2.5%   |
| Total           | $2,297K | $286K | 12.5% |

Early ideas: Furniture sells almost as much as Technology but barely makes money.
Central has the weakest margin. Big discounts (50%+) show large losses.

## My 5 KPIs
1. Total Revenue = sum of Sales
2. Avg Order Value = Total Revenue / number of distinct orders
3. Orders = count of distinct Order IDs (not rows: one order can have many rows)
4. Profit Margin % = sum of Profit / sum of Sales
5. Return Rate = returned orders / total orders (needs returns data, sorted on Day 2)
