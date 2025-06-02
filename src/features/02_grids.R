## src/features/02_grids.R
# State grid generation (reduced resolution: 8×5)

# libraries
library(dplyr)
library(here)

# load utils
source(here("src/features/utils_states.R"))

# Definition of breaks in X and Y (8 bins in X, 5 bins in Y)
x_breaks <- seq(0, 1, length.out = 9)   # 9 points generate 8 intervals
y_breaks <- seq(0, 1, length.out = 6)   # 6 points generate 5 intervals

# Building the state lookup
# For each combination of (x_bin, y_bin), we calculate state_id and lane
states_lookup <- expand.grid(
  x_bin = seq_len(length(x_breaks) - 1),
  y_bin = seq_len(length(y_breaks) - 1)
) |>
  rowwise() |>
  mutate(
    # Central coordinate of the cell in X and Y
    x_mid = (x_breaks[x_bin] + x_breaks[x_bin + 1]) / 2,
    y_mid = (y_breaks[y_bin] + y_breaks[y_bin + 1]) / 2,
    # unique state_id: (y_bin - 1) * (#bins in X) + x_bin
    state_id = (y_bin - 1) * (length(x_breaks) - 1) + x_bin,
    lane     = lane_name(ymin = y_breaks[y_bin], ymax = y_breaks[y_bin + 1])
  ) |>
  ungroup() |>
  select(state_id, x_bin, y_bin, lane, x_mid, y_mid)

# save output
saveRDS(states_lookup, here("data/derived/states_lookup.rds"))
message("states_lookup.rds created with 8×5 resolution (total: ", nrow(states_lookup), " states).")
