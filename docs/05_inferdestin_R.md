# 05_inferdestin.R

## Purpose
Infer the destination state probabilities (`dest_probs`) for each play using a pre-trained XGBoost model (or a stub). Reads classified plays and outputs `plays_dest.rds`, where each row gains a list‐column of probabilities over all possible destination states.

## Dependencies
- **R packages**:
  - `dplyr`
  - `tidyr`
  - `purrr`
  - `xgboost`
  - `here`
- **Helper script**:
  - `src/models/utils_dest.R` (provides `infer_destinations()`)

## Inputs
1. **`data/derived/plays.rds`**  
   Classified plays with `start_state`, `end_state`, `transition_flag`.
2. **`data/derived/events_clean.rds`**  
   Cleaned event data (360 frames included).
3. **`data/derived/states_lookup.rds`**  
   Grid lookup table (40 states).
4. **`models/xgb_dest_model.xgb`** (or `.rds`)  
   Pre-trained XGBoost model for predicting destination probabilities.
5. **`src/models/utils_dest.R`**  
   Contains `infer_destinations(…)`, which wraps XGBoost predictions into a list‐column.

## Outputs
- **`data/derived/plays_dest.rds`**  
  A data frame identical to `plays.rds` plus:
  - `dest_probs` (list‐column): numeric vector of length = n_states (40), summing to 1 for each play.
