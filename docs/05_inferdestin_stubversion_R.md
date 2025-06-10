# 05_inferdestin_stubversion.R

## Purpose
Provide a **stub** implementation of destination-state inference that assigns **uniform** probabilities across all states, allowing the pipeline to run without a real XGBoost model.

## Dependencies
- **R packages**:
  - `dplyr`
  - `purrr`
  - `here`
- **Helper script**:
  - `src/models/utils_dest.R` (provides `expand_with_weights()`, but `infer_destinations()` is bypassed)

## Inputs
1. **`data/derived/plays.rds`**  
   Classified plays with `start_state`, `end_state`, `transition_flag`.
2. **`data/derived/states_lookup.rds`**  
   Grid lookup table to determine `n_states` (e.g., 40).
3. **Batch Size**  
   - Not used; this stub applies uniform probabilities in one pass.

## Outputs
- **`data/derived/plays_dest.rds`**  
  Plays data frame with an added `dest_probs` column, where each entry is a uniform probability vector of length = n_states (summing to 1), bypassing any model inference.
