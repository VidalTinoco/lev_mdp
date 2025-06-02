# 02_generate_events_states.R

## Purpose
Assign each event in the cleaned StatsBomb dataset a discrete `state_id` based on its `(x, y)` coordinates and time. Outputs `events_states.rds`, which adds a `state_id` column to `events_clean.rds`.

## Dependencies
- **R packages**:
  - `here`
  - `dplyr`
- **Helper script**:
  - `src/features/utils_states.R` (defines `assign_state()`)

## Inputs
1. **`data/derived/events_clean.rds`**  
   Cleaned event data produced by `01_data_loading_cleaning.R`.
2. **`src/features/utils_states.R`**  
   Contains the `assign_state(x, y, dt, x_breaks, y_breaks)` function.

## Outputs
- **`data/derived/events_states.rds`**  
  Same rows as `events_clean.rds`, plus:
  - `state_id` (integer ∈ [1, 40]) calculated with an 8×5 grid:
    - `x_breaks = seq(0, 1, length.out = 9)`  
    - `y_breaks = seq(0, 1, length.out = 6)`