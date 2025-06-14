# train_xgb_dest.R

## Purpose
Train an XGBoost multiclass model to predict the destination state (`end_state`) of each pass, using a sampled subset of the plays dataset to limit memory usage. Saves the resulting model in both binary (`.xgb`) and RDS formats.

## Dependencies
- **R packages**:
  - `dplyr`
  - `here`
  - `xgboost`
  - `tidyr`
- **Helper files**:
  - `data/derived/plays.rds` (input plays)
  - `data/derived/states_lookup.rds` (to determine number of classes)

## Inputs
1. **`data/derived/plays.rds`**  
   Data frame of classified plays containing at least:
   - `start_state` (integer)
   - `end_state`   (integer or `NA`)
   - `location.x`, `location.y`  
   - `pass.end_location.x`, `pass.end_location.y`

2. **Sampling fraction**  
   - Hardcoded `sample_frac(0.5)` to reduce the training set by 50%.

3. **`states_lookup.rds`**  
   - Used to read `n_states = nrow(states_lookup)` (40 classes for the 8×5 grid).

## Outputs
- **`models/xgb_dest_model.xgb`**  
  Binary XGBoost model file (for fast loading with `xgb.load()`).

- **`models/xgb_dest_model.rds`**  
  RDS-serialized model object (for loading with `readRDS()`).
