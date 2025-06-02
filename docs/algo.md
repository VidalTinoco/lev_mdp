# 01_data_loading_cleaning.R

## Purpose
Load raw StatsBomb event and 360 data (previously combined by `00_load_data.R`), perform filtering and cleaning specific to the target competition/season (e.g., Bundesliga 2023–24), and save the cleaned result as `events_clean.rds`. This cleaned dataset is ready for feature extraction and downstream processing.

## Dependencies
- **R packages**:
  - `here`
  - `dplyr`
  - `purrr`
  - `jsonlite` (if any JSON parsing is needed)
- **Helper script**:
  - `src/io/utils.R` (utility functions for merging, filtering, or normalizing)

## Inputs
1. **`data/derived/events_clean_raw.rds`**  
   Combined raw event + 360 data from `00_load_data.R`.
2. **Filtering parameters** (hardcoded or passed via `utils.R`), for example:
   - Target `competition_id` (e.g., Bundesliga)
   - Target `season_id` (e.g., 2023–24)
   - Flags for including only events with 360 data or specific play patterns

## Outputs
- **`data/derived/events_clean.rds`**  
  Filtered and cleaned event data, containing only:
  - Selected competition & season
  - Events with valid X/Y coordinates
  - Merged 360 data where available
  - Columns normalized (numeric timestamps, flattened nested lists, etc.)
