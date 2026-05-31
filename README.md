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
                                   │  - Cross-Filter Matrix   │
                                   └──────────────────────────┘