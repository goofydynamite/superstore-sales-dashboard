# Walkthrough (about 60 seconds)

KPI cards:
"This is four years of Superstore sales, around 2.3 million dollars from about 5,000 orders. Revenue grew 20% in 2017, but the average order got smaller and margin dipped a bit, so the growth is coming from more orders rather than bigger ones."

Region chart:
"The main question was which regions are growing and which aren't. West and South both grew over 30%. Central didn't grow at all, and its margin fell from 13.5% to about 5%. That's where I'd look first."

Discount chart:
"I think discounting explains a lot of it. Anything discounted more than 20% loses money. Those sales brought in 363K and lost 135K, so I'd cap discounts at 20%."

Bottom 10 table:
"The worst products are mostly 3D printers and conference tables sold at 40 to 50% off. Furniture as a whole only makes a 2.5% margin."

Slicers:
"You can filter everything by region, category and segment. I cleaned the data in PostgreSQL first and built this in Excel with pivot tables."


## Headlines

- Central is the only region not growing, and its margin fell from 13.5% to 5.1% in 2017
- Discounts over 20% lose money: $363K of sales, $135K loss
- Furniture is 32% of revenue but only a 2.5% margin


## Questions they might ask

Why these KPIs?
Revenue on its own can look good while the business loses money, so I added margin. Orders and average order value show whether growth comes from more customers or bigger baskets. Return rate is there to catch quality problems.

Why this layout?
KPIs on top because that's what people look at first, then the trend and regions since that's the actual question, then product detail at the bottom.

What would someone use it for on a Monday?
To see if sales are ahead of last year, whether a region or category is slipping, and which products are being sold at a loss.

What data problems did you find?
Dates came in as text, one duplicate row, postal codes missing leading zeros, and no returns column, so I joined a separate returns table. Orders had to be a distinct count because one order can have several rows.

Why doesn't the region slicer filter the region chart?
That chart compares the four regions, so filtering to one region would make it pointless.
