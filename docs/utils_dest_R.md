# utils_dest.R

## Purpose
Provide core utility functions for destination-inference and probability expansion:

1. **`closest_teammate_cell()`**  
   - Compute the `state_id` of the nearest teammate to a pass vector (used when 360 freeze frames are available).

2. **`dist_line_to_point()`**  
   - Calculate the perpendicular distance from a point (teammate) to the line defined by the pass origin and end.

3. **`extract_features()`**  
   - Stub placeholder to generate the exact feature set for XGBoost (e.g., origin cell, angle, log-dist).  

4. **`eval_xgb_probs()`**  
   - Wrap XGBoost `predict()` into a matrix of shape `(n_plays × n_states)`.

5. **`infer_destinations()`**  
   - Main function that, per play, chooses between:
     - **360° frame logic**: use `closest_teammate_cell()` when available.  
     - **Model logic**: apply `extract_features()` + `eval_xgb_probs()` via XGBoost.

6. **`expand_with_weights()`**  
   - Unnest a list-column of probability vectors into a long table with `(end_state, weight)` rows.

## Dependencies
- `dplyr`, `tidyr`, `purrr`, `xgboost`, `here`

## Inputs
- **Per-play data**: columns like `x_start`, `y_start`, `x_end`, `y_end`, `state_start`, `teammate_positions_list`.
- **`xgb_model`**: pre-trained XGBoost booster.
- **`states_lookup` & grid breaks**: to map coordinates to `state_id`.

## Outputs
- Functions loaded into environment; no files written directly.
- `infer_destinations()` returns a data frame with a `dest_probs` list-column.
- `expand_with_weights()` transforms that column into explicit `(end_state, weight)` rows.
