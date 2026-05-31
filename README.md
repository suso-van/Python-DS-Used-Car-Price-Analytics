# Used Car Price Analytics

An end-to-end analytics project for ingesting used-car listing data, normalizing it into a relational warehouse model, and serving depreciation and market pulse metrics to BI dashboards.

## Project Layout

```text
used-car-price-analytics/
├── data/                 # Raw and processed datasets; large files are gitignored
├── sql/                  # Database schema, analytical views, and quality checks
├── bi_dashboards/        # Power BI and Tableau dashboard assets
├── scripts/              # Python ingestion and loading automation
└── docs/                 # Data dictionary and architecture notes
```

## Pipeline

1. Store source extracts under `data/raw/`.
2. Load CSV data into the database with `scripts/load_to_db.py`.
3. Create normalized tables using `sql/schema/create_tables.sql`.
4. Build analytical views from `sql/transformations/`.
5. Run quality checks from `sql/data_quality/outlier_detection.sql`.
6. Connect Power BI or Tableau to the transformed views.

## Setup

Create a virtual environment and install the Python dependencies you need for your database target:

```bash
python -m venv .venv
source .venv/bin/activate
pip install pandas sqlalchemy psycopg2-binary
```

Set a database URL before loading data:

```bash
export DATABASE_URL="postgresql+psycopg2://user:password@localhost:5432/used_cars"
python scripts/load_to_db.py data/raw/listings.csv
```

## Key Tables

- `dim_brands`: brand-level reference data.
- `dim_vehicles`: vehicle attributes such as model, trim, year, fuel type, and transmission.
- `fact_listings`: listing-level observations including price, mileage, seller type, geography, and listing date.
