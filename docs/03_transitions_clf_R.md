# 03_transitions_clf.R

## Purpose
Provide specialized transition detection functions for use in play classification. Specifically, it implements:
1. `is_transition()` – determines if a single event constitutes a possession change within a short time window.
2. `is_transition_vec()` – vectorized version that flags transitions across an entire column of events.

These functions enable `classify_actions()` to mark when possession shifts (e.g., after a turnover or tackle).

## Dependencies
- **R packages**:
  - `dplyr` (for optional data‐frame manipulations, though core logic is base‐R)

## Inputs
- Functions do not read external files. They require, at call time:
  - `team_ids` (integer vector of team IDs, one per event)
  - `times` (numeric or POSIX elapsed‐time vector, matching `team_ids`)
  - `focal_team` (integer ID of the team of interest)
  - `window_secs` (numeric time window, in seconds, to detect quick transitions)

## Outputs
- None written to disk. When sourced, this script defines:
  - `is_transition(team_ids, times, focal_team, window_secs)`  
    Returns `TRUE`/`FALSE` for a single event if it’s a transition.
  - `is_transition_vec(team_ids, times, focal_team, window_secs)`  
    Returns a logical vector marking transitions across all events.
