-- Drop tables if they exist to allow clean iterative builds
DROP TABLE IF EXISTS fact_listings CASCADE;
DROP TABLE IF EXISTS dim_vehicles CASCADE;
DROP TABLE IF EXISTS dim_brands CASCADE;

-- 1. Dimension Table: Brands
CREATE TABLE dim_brands (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Dimension Table: Vehicle Specs
CREATE TABLE dim_vehicles (
    vehicle_id INT PRIMARY KEY,
    brand_id INT,
    model_name VARCHAR(100) NOT NULL,
    fuel_type VARCHAR(50),
    transmission_type VARCHAR(50),
    engine_size_liters DECIMAL(3, 1),
    FOREIGN KEY (brand_id) REFERENCES dim_brands(brand_id) ON DELETE CASCADE
);

-- 3. Core Metric Table: Fact Listings
CREATE TABLE fact_listings (
    listing_id INT PRIMARY KEY,
    vehicle_id INT,
    model_year INT NOT NULL,
    mileage INT NOT NULL,
    tax_amt DECIMAL(10, 2),
    mpg DECIMAL(6, 2),
    price DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES dim_vehicles(vehicle_id) ON DELETE CASCADE
);