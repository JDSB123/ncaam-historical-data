# NCAAM Historical Data (Local Root)

This repo holds canonical historical datasets used for backtesting and model validation.
It lives inside `NCAAM_main/ncaam_historical_data_local` and is versioned separately from the
main model code.

## Structure
- `odds/raw/` - Raw pulls from The Odds API (gitignored, synced to Azure Blob)
- `odds/canonical/` - Canonical odds outputs (spreads/totals by period)
- `scores/fg/` - Full-game results from ESPN
- `scores/h1/` - First-half results from ESPN boxscores
- `ratings/raw/barttorvik/` - Barttorvik season ratings
- `team_resolution/` - Team name resolution artifacts
- `backtest_datasets/` - Derived datasets for backtests
- `schemas/` / `manifests/` - Optional schema and checksum files
- `ncaahoopR_data-master/` - Play-by-play data (6.7 GB, gitignored, synced to Azure Blob)

## Ingestion (from NCAAM_main)
- `testing/scripts/fetch_historical_odds.py` -> `odds/raw/`
- `testing/scripts/canonicalize_historical_odds.py` -> `odds/canonical/`
- `testing/scripts/fetch_historical_data.py` -> `scores/fg/` and `ratings/raw/barttorvik/`
- `testing/scripts/fetch_h1_data.py` -> `scores/h1/`

Override the default root with `HISTORICAL_DATA_ROOT` if needed.

## Azure Blob Storage (Raw Data Backup)
Raw data that's too large for GitHub is synced to Azure Blob Storage:

- **Storage Account**: `metricstrackersgbsv` (dashboard-gbsv-main-rg)
- **Container**: `ncaam-historical-raw`
- **Contents**:
  - `odds/raw/archive/` - 210+ raw API CSV files (~139K+ rows)
  - `ncaahoopR_data-master/` - Play-by-play data (6.7 GB)

### Sync Command
```bash
# From NCAAM_main directory
python scripts/sync_raw_data_to_azure.py           # Upload raw odds
python scripts/sync_raw_data_to_azure.py --dry-run # Preview without uploading
python scripts/sync_raw_data_to_azure.py --include-ncaahoopR  # Include 6.7GB pbp data
```

Run this after any major data ingestion to ensure raw data is backed up.

## Data Coverage Summary (as of January 2026)

### Scores Data (ESPN)
| Season | FG Games | H1 Games | Date Range |
|--------|----------|----------|------------|
| 2019   | 1,154    | 1,154    | 2018-11-07 to 2019-04-09 |
| 2020   | 856      | 857      | 2019-11-05 to 2020-03-12 |
| 2021   | 879      | 879      | 2020-11-25 to 2021-04-06 |
| 2022   | 1,095    | 1,104    | 2021-11-09 to 2022-04-05 |
| 2023   | 1,172    | 1,172    | 2022-11-07 to 2023-04-04 |
| 2024   | 928      | 930      | 2023-11-06 to 2024-04-09 |
| 2025   | 967      | 978      | 2024-11-04 to 2025-04-08 |
| 2026   | 449+     | 450+     | 2025-11-03 to present |

### Odds Data (The Odds API)
| Season | FG Spread | H1 Spread | Backtest Ready |
|--------|-----------|-----------|----------------|
| 2019   | ❌ None   | ❌ None   | No |
| 2020   | ❌ None   | ❌ None   | No |
| 2021   | ✅ 6,692  | ⏳ Pending | FG Only |
| 2022   | ✅ 4,852  | ⏳ Pending | FG Only |
| 2023   | ✅ 5,187  | ⏳ Pending | FG Only |
| 2024   | ✅ 5,687  | ✅ 5,389  | Full |
| 2025   | ✅ 5,741  | ✅ 5,587  | Full |
| 2026   | ✅ 2,392  | ✅ 2,304  | In Progress |

### Known Limitations
1. **H1 Historical Odds**: The Odds API historical endpoint may not return H1 spreads for older seasons (2021-2023). H1 backtest coverage is limited to seasons 2024+.
2. **Odds API Coverage**: Data begins ~Nov 2020. Seasons 2019-2020 have no odds data.
3. **ncaahoopR Data**: Too large for GitHub (6.7 GB). Synced to Azure Blob Storage.

## Publishing
1. **Canonical data**: Commit to this repo (pushed to GitHub)
2. **Raw data**: Sync to Azure Blob Storage with `scripts/sync_raw_data_to_azure.py`

Both steps should be run after any major data ingestion.
