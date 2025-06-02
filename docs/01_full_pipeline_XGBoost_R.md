# 01_full_pipeline_XGBoost.R

## Purpose
Automate the entire “full” pipeline, from raw StatsBomb events to final aggregated transition counts, using an XGBoost model for destination inference. Running this script executes all intermediate steps in sequence, producing:

1. `events_clean.rds`  
2. `states_lookup.rds` (8×5 grid)  
3. `events_states.rds`  
4. `plays.rds`  
5. `xgb_dest_model.xgb` (and `.rds`)  
6. `plays_dest.rds`  
7. `trans_counts_agg.rds`

## Dependencies
- **R interpreter**   
- **R packages** (must be installed):  
  - `here`  
  - `dplyr`  
  - `xgboost`  
  - `tidyr`  
  - `purrr`  
- **System utilities**: ability to run `Rscript` from the command line  
- All following helper scripts in their respective locations:  
  - `src/io/01_data_loading_cleaning.R`  
  - `src/features/02_grids.R`  
  - `run/02_generate_events_states.R`  
  - `src/features/03_transitions.R`  
  - `run/03_generate_plays.R`  
  - `src/models/train_xgb_dest.R`  
  - `src/models/05_inferdestin_batched.R`  
  - `src/models/05_1_weighted_expansion_agg.R`

## Inputs
1. **Raw StatsBomb event files** (expected in `data/raw/`, e.g. JSON or RDS), consumed by `01_data_loading_cleaning.R`  
2. **Helper scripts** (listed above), which assume:  
   - `src/io/utils.R` (utility functions)  
   - `src/features/utils_states.R` (grid‐assignment function)  
   - `src/models/utils_dest.R` (destination‐inference utilities)

## Outputs
Upon successful execution, the following files appear:

- **`data/derived/events_clean.rds`**  
  Cleaned event data (StatsBomb events + 360 frames merged).

- **`data/derived/states_lookup.rds`**  
  Grid lookup with 40 rows (8×5).

- **`data/derived/events_states.rds`**  
  Events annotated with `state_id` ∈ [1, 40].

- **`data/derived/plays.rds`**  
  Classified plays (start_state, end_state, transition_flag).

- **`models/xgb_dest_model.xgb`** and **`models/xgb_dest_model.rds`**  
  Trained XGBoost model for predicting destination states (40 classes).

- **`data/derived/plays_dest.rds`**  
  Plays with appended `dest_probs` (vector of 40 probabilities each).

- **`data/derived/trans_counts_agg.rds`**  
  Aggregated transition‐count table `(origin_state, dest_state, total_weight)`.

