"""Optional entry point for collecting used-car listing extracts.

This file is intentionally conservative: many listing sites have strict terms
of service. Add source-specific extraction code only after confirming that the
source permits automated collection.
"""

from __future__ import annotations

import argparse
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser(description="Create a placeholder raw listing extract.")
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("data/raw/sample_listings.csv"),
        help="Output CSV path.",
    )
    args = parser.parse_args()

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        "source_listing_id,brand_name,model_name,trim_name,model_year,body_type,"
        "fuel_type,transmission,engine_cc,listed_price,mileage_km,owner_count,"
        "seller_type,city,state,listing_date,listing_url\n",
        encoding="utf-8",
    )
    print(f"Created starter extract at {args.output}")


if __name__ == "__main__":
    main()
