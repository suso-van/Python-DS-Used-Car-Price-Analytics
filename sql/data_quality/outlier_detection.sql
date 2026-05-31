-- 1. Listings with invalid or suspiciously low/high prices
SELECT
    fl.listing_id,
    db.brand_name,
    dv.model_name,
    fl.model_year,
    fl.price,
    fl.mileage
FROM fact_listings fl
JOIN dim_vehicles dv ON fl.vehicle_id = dv.vehicle_id
JOIN dim_brands db   ON dv.brand_id = db.brand_id
WHERE fl.price <= 500 OR fl.price > 150000
ORDER BY fl.price ASC;

-- 2. Listings with unusually high mileage (Converting 300k km check to ~185k miles)
SELECT
    fl.listing_id,
    db.brand_name,
    dv.model_name,
    fl.model_year,
    fl.price,
    fl.mileage
FROM fact_listings fl
JOIN dim_vehicles dv ON fl.vehicle_id = dv.vehicle_id
JOIN dim_brands db   ON dv.brand_id = db.brand_id
WHERE fl.mileage > 185000
ORDER BY fl.mileage DESC;

-- 3. Duplicate checks based on identical vehicle stats
-- (Since the raw CSVs lack a unique 'source_id', we check for matching physical fingerprints)
SELECT 
    vehicle_id, 
    model_year, 
    mileage, 
    price, 
    COUNT(*) AS duplicate_count
FROM fact_listings
GROUP BY vehicle_id, model_year, mileage, price
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;