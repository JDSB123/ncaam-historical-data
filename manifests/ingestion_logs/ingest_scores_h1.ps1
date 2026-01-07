$root = "C:\Users\JB\green-bier-ventures\NCAAM_main"
$dataRoot = Join-Path $root "ncaam_historical_data_local"
$fgAll = Join-Path $dataRoot "scores\fg\games_all.csv"
$h1All = Join-Path $dataRoot "scores\h1\h1_games_all.csv"
python (Join-Path $root "testing\scripts\fetch_historical_data.py") --seasons 2019-2026
python (Join-Path $root "testing\scripts\fetch_h1_data.py") --input $fgAll --output $h1All
