# 02_grids.R

## Purpose
Generate a lookup table (`states_lookup.rds`) for an 8×5 grid overlay on the pitch. This table maps any `(x, y)` coordinate pair to a discrete `state_id`. It also records the center of each cell (`x_mid`, `y_mid`) and a `lane` label. Downstream scripts use this lookup to assign each event or pass to one of 40 states.

## Dependencies
- **R packages**:
  - `here`
  - `dplyr`
- **Helper script**:
  - `src/features/utils_states.R` (provides `lane_name()` to assign a lane label)

## What Is the Lookup Table?
A **lookup table** here is a data frame that encodes every possible cell in the grid and its associated metadata. Concretely:

1. **Grid Definition**  
   - We divide the normalized pitch into 8 columns (X direction) and 5 rows (Y direction), so there are 8×5 = 40 total cells.
   - `x_breaks = seq(0, 1, length.out = 9)` produces 9 boundary points (0.0, 0.125, 0.25, …, 1.0), which define 8 equal-width intervals in X.
   - `y_breaks = seq(0, 1, length.out = 6)` produces 6 boundary points (0.0, 0.2, 0.4, …, 1.0), which define 5 equal-height intervals in Y.

2. **Cell Indices (`x_bin`, `y_bin`)**  
   - For each combination of `x_bin ∈ {1…8}` and `y_bin ∈ {1…5}`, there is one cell.
   - `x_bin` = column index from left to right; `y_bin` = row index from bottom to top (or however you choose to orient, but consistently).

3. **State ID (`state_id`)**  
   - Each cell is assigned a unique integer `state_id` from 1 to 40.  
   - Calculation:  
     ```
     state_id = (y_bin - 1) * (number_of_x_bins) + x_bin
     ```
     For example:
     - Cell with (x_bin = 1, y_bin = 1) → `state_id = (1-1)*8 + 1 = 1`
     - Cell with (x_bin = 8, y_bin = 5) → `state_id = (5-1)*8 + 8 = 40`

4. **Center Coordinates (`x_mid`, `y_mid`)**  
   - For each cell, `x_mid` = midpoint of the X-interval, `y_mid` = midpoint of the Y-interval.  
   - These midpoints can be used for feature creation or plotting.

5. **Lane Label (`lane`)**  
   - We assign a human-readable `lane` (e.g., `lane_1`, `lane_2`, …) according to the Y-interval.  
   - The helper function `lane_name(ymin, ymax)` (in `utils_states.R`) maps a Y-range to a string like `"lane_1"`.

### How It’s Used
- **Assigning an Event to a State**  
  Given an event’s normalized `(x, y)` coordinate:
  1. Find which interval in `x_breaks` contains `x`.
  2. Find which interval in `y_breaks` contains `y`.
  3. Look up `(x_bin, y_bin)` to get `state_id`.
- This mapping is done via the `assign_state()` function in `utils_states.R`, which references this lookup table structure.

---

## Inputs
- None file-based. Internally, this script defines:
  - `x_breaks = seq(0, 1, length.out = 9)` (8 equal intervals in X)
  - `y_breaks = seq(0, 1, length.out = 6)` (5 equal intervals in Y)
- Relies on `lane_name()` from `src/features/utils_states.R` to compute `lane`.

## Outputs
- **`data/derived/states_lookup.rds`**  
  A tibble with 40 rows, each representing one cell in the 8×5 grid. Columns include:
  - `state_id` (integer 1–40)
  - `x_bin` (integer 1–8)
  - `y_bin` (integer 1–5)
  - `lane` (character, e.g., `lane_1`, `lane_2`, …)
  - `x_mid` (numeric, center of the cell in X)
  - `y_mid` (numeric, center of the cell in Y)
