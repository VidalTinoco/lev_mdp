# 05_inferdestin_batched.R

## Purpose
Perform destination-state inference in batches to limit memory usage. Splits the full plays dataset into manageable chunks, applies the trained XGBoost model to each batch to compute `dest_probs`, and then combines the results into `plays_dest.rds`.

## Dependencies
- **R packages**:
  - `dplyr`
  - `purrr`
  - `xgboost`
  - `here`
- **Helper script**:
  - `src/models/utils_dest.R` (defines any supporting functions such as feature extraction and the `infer_destinations()` wrapper)

## Inputs
1. **`data/derived/plays.rds`**  
   Classified plays with `start_state`, `end_state`, `transition_flag`.
2. **`data/derived/events_clean.rds`**  
   Cleaned event data for contextual features (e.g., freeze_frame).
3. **`data/derived/states_lookup.rds`**  
   Grid lookup table to determine `n_states` (e.g., 40).
4. **`models/xgb_dest_model.xgb`**  
   Pre-trained XGBoost model file.
5. **Batch Size**  
   - Hardcoded or parameterized (e.g., `batch_sz <- 2000`), controlling how many plays to process at once.

## Outputs
- **`data/derived/plays_dest.rds`**  
  Combined data frame of all plays with an added column:
  - `dest_probs` (list‐column): vector of length = n_states (40), containing predicted probabilities.
