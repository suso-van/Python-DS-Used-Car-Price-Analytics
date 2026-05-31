-- Clear out old records if re-running the script to avoid key conflicts
TRUNCATE TABLE fact_listings CASCADE;
TRUNCATE TABLE dim_vehicles CASCADE;
TRUNCATE TABLE dim_brands CASCADE;

-- ==========================================
-- 1. POPULATE DIM_BRANDS
-- ==========================================
-- Extracts unique brand names from the raw staging data and assigns an ID
INSERT INTO dim_brands (brand_id, brand_name)
SELECT 
    ROW_NUMBER() OVER (ORDER BY brand_name) AS brand_id,
    brand_name
FROM (
    SELECT DISTINCT brand_name 
    FROM stg_raw_listings
) b;

-- ==========================================
-- 2. POPULATE DIM_VEHICLES
-- ==========================================
-- Extracts unique configurations of models, fuel types, transmission types, and engine sizes
INSERT INTO dim_vehicles (vehicle_id, brand_id, model_name, fuel_type, transmission_type, engine_size_liters)
SELECT 
    ROW_NUMBER() OVER (ORDER BY b.brand_id, s.model) + 1000 AS vehicle_id,
    b.brand_id,
    TRIM(s.model) AS model_name,
    TRIM(s.fueltype) AS fuel_type,
    TRIM(s.transmission) AS transmission_type,
    s.enginesize AS engine_size_liters
FROM (
    SELECT DISTINCT brand_name, model, fueltype, transmission, enginesize 
    FROM stg_raw_listings
) s
JOIN dim_brands b ON s.brand_name = b.brand_name;

-- ==========================================
-- 3. POPULATE FACT_LISTINGS
-- ==========================================
-- Links transactional data to the dimension tables using natural key matching
INSERT INTO fact_listings (listing_id, vehicle_id, model_year, mileage, tax_amt, mpg, price)
SELECT 
    ROW_NUMBER() OVER () AS listing_id,
    v.vehicle_id,
    stg.year,
    stg.mileage,
    CAST(stg.tax AS DECIMAL(10,2)),
    CAST(stg.mpg AS DECIMAL(6,2)),
    CAST(stg.price AS DECIMAL(12,2))
FROM stg_raw_listings stg
JOIN dim_brands b ON stg.brand_name = b.brand_name
JOIN dim_vehicles v ON b.brand_id = v.brand_id 
    AND TRIM(stg.model) = v.model_name 
    AND TRIM(stg.fueltype) = v.fuel_type 
    AND TRIM(stg.transmission) = v.transmission_type
    AND stg.enginesize = v.engine_size_liters;