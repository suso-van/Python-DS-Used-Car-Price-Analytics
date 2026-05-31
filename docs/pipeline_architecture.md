# Pipeline Architecture

```text
Raw listing CSVs
    -> scripts/load_to_db.py
    -> stg_used_car_listings
    -> sql/schema/create_tables.sql
    -> dim_brands + dim_vehicles + fact_listings
    -> sql/transformations/*.sql
    -> Power BI / Tableau dashboards
```

The architecture separates ingestion, normalization, quality testing, and BI serving layers so each part can be validated independently.
