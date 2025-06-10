# 01_data_loading_cleaning.R

## Purpose
Load the pre-cleaned StatsBomb 360 dataset (`StatsbombData360.rds`), remove empty columns and rescale pitch coordinates if needed, then write out the final cleaned data as `events_clean.rds`.

## Dependencies
- **R packages**:
  - `dplyr`    (data manipulation)
  - `here`     (file paths)
  - `jsonlite` (JSON utilities, if needed by helpers)
  - `readr`    (fast RDS reading/writing)
- **Helper script**:
  - `src/io/utils.R` (defines `all_na()` and `scale_if_needed()`)

## Inputs
- **`data/raw/StatsbombData360.rds`**  
  A single RDS file containing the merged StatsBomb event and 360-frame data for all matches of interest.

## Outputs
- **`data/derived/events_clean.rds`**  
  The same data frame after:
  1. **`all_na()`**: dropping any column composed entirely of `NA`.  
  2. **`scale_if_needed()`**: if any `x` or `y` values exceed 1, assume they are in 0–100 and rescale them to 0–1.  
