# 05_1_weighted_expansion.R

## Purpose
Expand the per‐play probability vectors (`dest_probs`) into a long table with one row per `(origin_state, dest_state)` pair and a corresponding weight. This fully “unnests” the list‐column of probabilities to facilitate downstream analyses that require explicit transition counts.

## Dependencies
- **R packages**:
  - `dplyr`
  - `tidyr`
  - `here`
- **Helper script**:
  - `src/models/utils_dest.R` (defines `expand_with_weights()`)

## Inputs
1. **`data/derived/plays_dest.rds`**  
   Data frame of plays with a list‐column `dest_probs` of length = number of states (e.g., 40) for each row.

## Outputs
- **`data/derived/trans_counts.rds`**  
  Long‐format data frame where each row represents one transition weighted by probability:
  - `origin_state` (integer)  
  - `end_state`    (integer)  
  - `weight`       (numeric probability)
