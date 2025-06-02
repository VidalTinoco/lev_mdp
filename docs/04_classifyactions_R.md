# 04_classifyactions.R

## Purpose
Define `classify_actions()`, which labels each event as a “play” by:
1. Sorting events chronologically.
2. Flagging possession changes (`transition_flag`).
3. Assigning a discrete `start_state` and `end_state` (using the 8×5 grid).
This produces a data frame where each row retains original event data plus the new columns needed for downstream MDP modeling.

## Dependencies
- **R packages**:
  - `dplyr`
  - `here`
- **Helper scripts** (must be sourced within):
  - `src/features/02_grids.R` (provides `assign_state()` configured for an 8×5 grid)
  - `src/features/03_transitions_clf.R` (provides `is_transition_vec()`)

## Inputs
- **Function arguments**:
  - `events_df` (data frame): Cleaned events (e.g., from `events_clean.rds`)
  - `focal_team` (integer): Team ID to monitor for transitions (e.g., 165)
  - `window_secs` (numeric): Time window (in seconds) for detecting quick possession changes
- **Columns expected in `events_df`**:
  - `team.id` (integer)
  - `ElapsedTime` (numeric or POSIX)
  - `location.x`, `location.y` (numeric, normalized to [0,1])
  - `pass.end_location.x`, `pass.end_location.y` (numeric or NA)
  - `type.name` (character, to detect “Pass”)

## Outputs
- Returns a data frame identical to `events_df` plus:
  - `transition_flag` (logical): `TRUE` if possession changed within `window_secs`
  - `start_state` (integer ∈ [1,40]): grid cell of `(location.x, location.y)`
  - `end_state` (integer ∈ [1,40] or same as `start_state` if not a pass)

No files are written; the result is typically saved by the calling script (e.g., inside `run/03_generate_plays.R`).
