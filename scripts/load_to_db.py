import os
import glob
import pandas as pd
from sqlalchemy import create_engine, text

# 1. Database Connection String (PostgreSQL Homebrew default)
DB_URL = 'postgresql://localhost:5432/used_cars_db'
engine = create_engine(DB_URL)
# 2. File Ingestion Path
RAW_DATA_PATH = "../data/raw/archive/"
csv_files = glob.glob(os.path.join(RAW_DATA_PATH, "*.csv"))

print(f"🚀 Found {len(csv_files)} target source files.")

# Securely clear out any half-baked staging data from the failed run
with engine.begin() as conn:
    conn.execute(text("DROP TABLE IF EXISTS stg_raw_listings;"))
    print("🗑️ Cleared existing staging environment to prepare for clean reload.")

# 3. Pipeline Ingestion Engine
for file_path in csv_files:
    file_name = os.path.splitext(os.path.basename(file_path))[0]
    
    # Ignore explicitly labeled unclean sets or hidden system files
    if "unclean" in file_name.lower() or file_name.startswith('.'):
        continue
        
    brand_name = file_name.capitalize()
    print(f"📥 Pipeline streaming -> Ingesting: {brand_name}")
    
    # Read the file
    df = pd.read_csv(file_path)
    
    # --- ADVANCED HEADERS CLEANING LAYER ---
    # 1. Strip spaces and lowercase everything
    df.columns = df.columns.str.lower().str.strip().str.replace(' ', '_')
    
    # 2. Explicitly map known structural anomalies found in Kaggle files
    df = df.rename(columns={
        'tax(£)': 'tax',
        'tax(€)': 'tax',
        'engine_size': 'enginesize'
    })
    # ----------------------------------------
    
    # Inject our tracking brand element
    df['brand_name'] = brand_name
    
    # Stream the data straight into PostgreSQL
    df.to_sql('stg_raw_listings', engine, if_exists='append', index=False)

print("\n✅ Data pipeline execution complete. All data loaded seamlessly into 'stg_raw_listings'!")