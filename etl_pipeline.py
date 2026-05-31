import subprocess
import os
from datetime import datetime

# Configuration Paths
DB_NAME = "used_cars_db"
PROCESSED_DIR = "/Users/susovanchatterjee/Documents/GitHub/Python-DS-Used-Car-Price-Analytics/data/processed"
MARKET_PULSE_CSV = os.path.join(PROCESSED_DIR, "v_market_pulse.csv")
DEPRECIATION_CSV = os.path.join(PROCESSED_DIR, "v_depreciation_model.csv")

def log_status(status_type, message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] [{status_type}] {message}")

def run_psql_cmd(command, success_msg):
    try:
        result = subprocess.run(
            ["psql", "-d", DB_NAME, "-c", command],
            capture_output=True,
            text=True,
            check=True
        )
        # Parse output for row counts (e.g., COPY 108540)
        output_clean = result.stdout.strip().replace("\n", " ")
        log_status("SUCCESS", f"{success_msg} -> {output_clean}")
    except subprocess.CalledProcessError as e:
        log_status("ERROR", f"Failed to execute command: {e.stderr.strip()}")
        raise e

def main():
    log_status("START", "Initiating Used-Car Analytics ETL Pipeline Refresh...")
    
    # 1. Rebuild Market Pulse View
    market_pulse_sql = """
    CREATE OR REPLACE VIEW v_market_pulse AS
    SELECT b.brand_name, v.model_name, f.model_year, COUNT(*) AS listing_count, ROUND(AVG(f.price)::numeric, 2) AS avg_price
    FROM fact_listings f
    JOIN dim_vehicles v ON f.vehicle_id = v.vehicle_id
    JOIN dim_brands b ON v.brand_id = b.brand_id
    GROUP BY b.brand_name, v.model_name, f.model_year;
    """
    run_psql_cmd(market_pulse_sql, "Compiled v_market_pulse view")

    # 2. Drop and Rebuild Depreciation View (To avoid structural mutation conflicts)
    run_psql_cmd("DROP VIEW IF EXISTS v_depreciation_model;", "Cleared old depreciation view entity")
    
    depreciation_sql = """
    CREATE VIEW v_depreciation_model AS
    SELECT b.brand_name, v.model_name, f.model_year, f.mileage, f.price, (2026 - f.model_year) AS car_age_years
    FROM fact_listings f
    JOIN dim_vehicles v ON f.vehicle_id = v.vehicle_id
    JOIN dim_brands b ON v.brand_id = b.brand_id;
    """
    run_psql_cmd(depreciation_sql, "Compiled v_depreciation_model view")

    # 3. Export Datasets to Target Processed Directory
    log_status("EXPORT", "Syncing database views to local storage files...")
    
    copy_pulse = f"\\copy (SELECT * FROM v_market_pulse) TO '{MARKET_PULSE_CSV}' WITH CSV HEADER"
    run_psql_cmd(copy_pulse, "Market Pulse Exported")
    
    copy_depreciation = f"\\copy (SELECT * FROM v_depreciation_model) TO '{DEPRECIATION_CSV}' WITH CSV HEADER"
    run_psql_cmd(copy_depreciation, "Depreciation Engine Exported")

    # 4. Target Destination Validation
    log_status("COMPLETE", "Pipeline execution finished flawlessly. Tableau-ready assets updated.")

if __name__ == "__main__":
    main()
    