# 03_generate_plays.R

## Purpose
Classify events into “plays” (i.e., passes and transitions) by assigning each pass a `start_state`, `end_state`, and a `transition_flag`. Outputs `plays.rds`, which contains one row per play with these new columns.

## Dependencies
- **R packages**:
  - `here`
  - `dplyr`
- **Helper script**:
  - `src/features/04_classifyactions.R` (defines `classify_actions()`)

## Inputs
1. **`data/derived/events_clean.rds`**  
   Cleaned event data from `01_data_loading_cleaning.R`.
2. **`data/derived/states_lookup.rds`**  
   Grid lookup (40 states) from `02_grids.R`.
3. **`src/features/04_classifyactions.R`**  
   Contains `classify_actions(events_df, focal_team, window_secs)` which:
   - Sorts events chronologically
   - Flags transitions (`transition_flag`)
   - Assigns `start_state` and `end_state` (8×5 grid)

## Outputs
- **`data/derived/plays.rds`**  
  A data frame with the same number of rows as `events_clean.rds`, plus columns:
  - `start_state` (integer ∈ [1, 40])
  - `end_state` (integer ∈ [1, 40] or `NA`)
  - `transition_flag` (logical)
