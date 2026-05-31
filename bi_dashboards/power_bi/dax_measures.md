# DAX Measures

Use this file to keep a text backup of production Power BI measures.

```DAX
Average Listed Price = AVERAGE('v_market_pulse'[avg_listed_price])

Median Listed Price = MEDIAN('v_depreciation_model'[listed_price])

Total Listings = SUM('v_market_pulse'[listing_count])

Average Mileage = AVERAGE('v_depreciation_model'[mileage_km])
```
