CREATE OR REPLACE VIEW v_depreciation_model AS
SELECT 
    f.listing_id,
    b.brand_name,
    v.model_name,
    v.fuel_type,
    v.transmission_type,
    v.engine_size_liters,
    f.model_year,
    -- Target Metric
    (EXTRACT(YEAR FROM CURRENT_DATE) - f.model_year) AS car_age_years,
    f.mileage,
    f.tax_amt,
    f.mpg,
    f.price,
    -- Engineered Metric: Evaluation Cost Efficiency
    ROUND((f.price / NULLIF(f.mileage, 0)), 4) AS price_per_mile
FROM fact_listings f
JOIN dim_vehicles v ON f.vehicle_id = v.vehicle_id
JOIN dim_brands b ON v.brand_id = b.brand_id
WHERE f.price > 100 AND f.mileage > 10; -- Excludes garbage/broken test data points