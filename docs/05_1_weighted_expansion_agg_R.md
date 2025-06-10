# 05_1_weighted_expansion_agg.R

## Purpose
Compute an **aggregated transition count** table without fully expanding the per‐play probability vectors. For each `origin_state`, it multiplies the number of plays by the uniform probability (1/ n_states) to produce a lightweight `(origin_state, dest_state, total_weight)` table.

## Dependencies
- **R packages**:
  - `dplyr`
  - `tidyr`
  - `here`

## Inputs
1. **`data/derived/plays_dest.rds`**  
   Data frame of plays with column `start_state` and list‐column `dest_probs` (length = n_states, e.g., 40).
2. **`data/derived/states_lookup.rds`**  
   Lookup table to determine `n_states` (rows in the grid, e.g., 40).

## Outputs
- **`data/derived/trans_counts_agg.rds`**  
  Aggregated transition table with columns:
  - `origin_state` (integer)  
  - `dest_state`   (integer)  
  - `total_weight` (numeric; sum of probabilities for each origin→dest across all plays)
