# 03_transitions.R

## Purpose
Compute “transition flags” that identify when possession changes between teams within a short timeframe (e.g., during a Gegenpress sequence). Provides helper functions to detect transitions based on team IDs and elapsed time, used later in `classify_actions()`.

## Dependencies
- **R packages**:
  - `dplyr`
- **No external inputs**; defines functions to be sourced by downstream scripts.

## Inputs
- None file-based. Defines two main functions:
  1. **`is_transition()`**  
     - Arguments:  
       - `team_ids` (vector of team IDs for consecutive events)  
       - `times` (vector of elapsed‐time values corresponding to those events)  
       - `focal_team` (integer ID of the team to check for)  
       - `window_secs` (numeric; time window in seconds)  
     - Returns: logical indicating if a change of possession occurs within `window_secs`.

  2. **`is_transition_vec()`**  
     - A vectorized wrapper over `is_transition()` that can be applied to entire columns in a data frame.  
     - Arguments (vectors):  
       - `team_ids`, `times`, plus scalar `focal_team`, `window_secs`.

These functions do not read or write any files; they simply return a logical vector marking transition events.

## Outputs
- No files produced. When sourced, makes `is_transition()` and `is_transition_vec()` available for use in `04_classifyactions.R`, where `transition_flag` is set per event.
