# Data Dictionary

## dim_brands

| Column | Type | Description |
| --- | --- | --- |
| brand_id | BIGSERIAL | Primary key. |
| brand_name | TEXT | Vehicle manufacturer name. |
| country_of_origin | TEXT | Optional brand origin metadata. |
| created_at | TIMESTAMP | Row creation timestamp. |

## dim_vehicles

| Column | Type | Description |
| --- | --- | --- |
| vehicle_id | BIGSERIAL | Primary key. |
| brand_id | BIGINT | Foreign key to `dim_brands`. |
| model_name | TEXT | Vehicle model name. |
| trim_name | TEXT | Optional trim or variant. |
| model_year | INTEGER | Manufacturing/model year. |
| body_type | TEXT | Body category such as sedan, SUV, or hatchback. |
| fuel_type | TEXT | Fuel category. |
| transmission | TEXT | Transmission category. |
| engine_cc | INTEGER | Engine displacement in cubic centimeters. |
| created_at | TIMESTAMP | Row creation timestamp. |

## fact_listings

| Column | Type | Description |
| --- | --- | --- |
| listing_id | BIGSERIAL | Primary key. |
| source_listing_id | TEXT | Source-system listing identifier. |
| vehicle_id | BIGINT | Foreign key to `dim_vehicles`. |
| listed_price | NUMERIC | Advertised listing price. |
| mileage_km | INTEGER | Odometer reading in kilometers. |
| owner_count | INTEGER | Number of previous owners, where available. |
| seller_type | TEXT | Dealer, individual, certified, or marketplace category. |
| city | TEXT | Listing city. |
| state | TEXT | Listing state or region. |
| listing_date | DATE | Date the listing was published or captured. |
| scrape_timestamp | TIMESTAMP | Timestamp when the listing was collected. |
| listing_url | TEXT | Source URL. |

## Analytical Metrics

| Metric | Source | Definition |
| --- | --- | --- |
| vehicle_age_years | `v_depreciation_model` | Listing year minus model year. |
| price_per_age_year | `v_depreciation_model` | Listed price divided by vehicle age. |
| price_per_km | `v_depreciation_model` | Listed price divided by mileage. |
| median_listed_price | `v_market_pulse` | Median listing price for each market segment. |
| listing_count | `v_market_pulse` | Number of listings in each market segment. |
