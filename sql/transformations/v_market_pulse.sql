CREATE OR REPLACE VIEW v_market_pulse AS
SELECT
    db.brand_name,
    dv.model_name,
    fl.model_year,
    dv.fuel_type,
    dv.transmission_type,
    -- Grouping chronologically using our pipeline's ingestion timestamp
    DATE_TRUNC('month', COALESCE(fl.date_crawled, CURRENT_DATE))::DATE AS listing_month,
    
    -- Analytical Aggregations
    COUNT(*) AS listing_count,
    ROUND(AVG(fl.price), 2) AS avg_price,
    ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fl.price) AS NUMERIC), 2) AS median_price,
    MIN(fl.price) AS min_price,
    MAX(fl.price) AS max_price,
    ROUND(AVG(fl.mileage), 0) AS avg_mileage_miles
FROM fact_listings fl
JOIN dim_vehicles dv ON fl.vehicle_id = dv.vehicle_id
JOIN dim_brands db   ON dv.brand_id = db.brand_id
GROUP BY
    db.brand_name,
    dv.model_name,
    fl.model_year,
    dv.fuel_type,
    dv.transmission_type,
    DATE_TRUNC('month', COALESCE(fl.date_crawled, CURRENT_DATE))::DATE;