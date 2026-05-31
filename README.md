# 🏎️ Automotive Marketplace ETL & Value Decay Engine

An optimized, end-to-end data engineering and business intelligence pipeline that transforms raw secondary automotive listings into actionable market insights. This system structures a production-ready PostgreSQL star schema, automates ETL orchestration via Python, and exposes advanced analytical tracking views for high-fidelity interactive visualization.

---

## 🛠️ System Architecture

```text
  [ Raw Listings Data ]
            │
            ▼
┌──────────────────────────┐
│ PostgreSQL Staging Layer │
└───────────┬──────────────┘
            │
            ▼
┌──────────────────────────┐
│    Core Star Schema      ├──────────────┐
│  - fact_listings         │              │
│  - dim_vehicles          │              │
│  - dim_brands            │              │
└───────────┬──────────────┘              │
            │                             │
            ▼ (Automated View Compiles)   ▼ (Python Automation)
┌──────────────────────────┐       ┌──────────────────────────┐
│  Analytical DB Views     │       │     etl_pipeline.py      │
│  - v_market_pulse        │ ───>  │  - View Refresh          │
│  - v_depreciation_model  │       │  - Zero-Byte Validation  │
└──────────────────────────┘       │  - Flat-File Syncing     │
                                   └──────────────┬───────────┘
                                                  │
                                                  ▼
                                   ┌──────────────────────────┐
                                   │  Tableau BI Dashboard    │
                                   │  - Value Decay Curves    │
                                   │  - Market Volume   │
                                   └──────────────────────────┘
                                    
```
💾 Database Design & Analytical ViewsThe storage engine implements an optimized Relational Star Schema utilizing foreign key cascading references to eliminate data redundancy and speed up query performance across 108k+ distinct listings.1. Market Pulse View (v_market_pulse)Aggregates macro market movements, processing bulk distribution metrics down to a lightweight 45KB tracking matrix.Granularity: Brand ➔ Model ➔ Model YearMetrics: Unique Listing Counts, Rounded Average Appraised Valuation.2. Asset Depreciation Engine (v_depreciation_model)Maintains 100% rows-level structural fidelity (3.5MB / 108,540 rows) to track individual asset degradation vectors.Calculated Dimensions: Continuous car_age_years baseline derived from active system time (2026 - model_year).Attributes Included: Brand Name, Model Name, Model Year, Mileage, Evaluated Market Price.⚙️ Automated ETL PipelineThe orchestration is handled entirely by etl_pipeline.py, a lightweight Python automation script utilizing native subprocess abstractions to safely rebuild analytical environments without manual data conflicts.Key Capabilities:Conflict Prevention: Executes drop-cascades before view initialization to bypass PostgreSQL's strict structural view-mutation blocks.Atomic Exports: Uses low-overhead native PostgreSQL binary streaming protocols via \copy to write clean, header-validated .csv payloads directly to target directories.Run Pipeline Manually:Bashpython etl_pipeline.py
Telemetry Output Stream:Plaintext[2026-05-31 14:45:01] [START] Initiating Used-Car Analytics ETL Pipeline Refresh...
[2026-05-31 14:45:01] [SUCCESS] Compiled v_market_pulse view -> CREATE VIEW
[2026-05-31 14:45:02] [SUCCESS] Cleared old depreciation view entity -> DROP VIEW
[2026-05-31 14:45:02] [SUCCESS] Compiled v_depreciation_model view -> CREATE VIEW
[2026-05-31 14:45:02] [EXPORT] Syncing database views to local storage files...
[2026-05-31 14:45:03] [SUCCESS] Market Pulse Exported -> COPY 1650
[2026-05-31 14:45:04] [SUCCESS] Depreciation Engine Exported -> COPY 108540
[2026-05-31 14:45:04] [COMPLETE] Pipeline execution finished flawlessly. Tableau-ready assets updated.
📊 Business Intelligence LayerThe frontend visualization engine maps out regression distributions to provide predictive tracking tools for analysts.Market Volume Tracking: Cross-examined horizontal bar grids mapped with conditional color gradients identifying premium vs. economic manufacturer distributions.Value Decay Curves: A non-aggregated high-fidelity scatter distribution plotting asset price positions against operational age vectors.Statistical Modeling: Integrated log-linear/exponential trend regression curves tracking mathematical depreciation speeds with real-time $R^2$ updates.Cross-Filtering Grid: Built-in dashboard interactivity where selector actions on the market volume components filter the localized regression matrix below instantly.Live Interactive Dashboard👉 Click here to view the full interactive dashboard🚀 Getting StartedPrerequisitesPostgreSQL 15+Python 3.10+Tableau Desktop / Public AccountSetup & RunClone the workspace:Bashgit clone [https://github.com/susovanchatterjee/Python-DS-Used-Car-Price-Analytics.git](https://github.com/susovanchatterjee/Python-DS-Used-Car-Price-Analytics.git)
cd Python-DS-Used-Car-Price-Analytics
Run the automated ETL pipeline to compile database entities and export clean analytical CSV outputs:Bashpython etl_pipeline.py
Check generated data footprints:Bashls -lh data/processed
Load the compiled outputs into your BI tool of choice and map visual assets.
***

### ⚡ Run These Terminal Commands to Push

Open your terminal window and drop this quick execution sequence to write the code and ship it to your remote GitHub branch instantly:

```bash
# 1. Overwrite your old README with this fresh production-grade build
cat << 'EOF' > README.md
(Paste the complete markdown code block from above right here in your terminal, then type EOF on a new line and hit Enter)