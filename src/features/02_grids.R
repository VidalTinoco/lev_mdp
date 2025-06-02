## src/features/02_grids.R
# State grid generation

# Libraries
library(dplyr)
library(here)

# load states utilities
source(here("src/features/utils_states.R"))

# Definition of cuts in X and Y
x_breaks <- seq(0, 1, length.out = 13)
y_breaks <- seq(0, 1, length.out = 8)

# Building the state lookup
states_lookup <- expand.grid(
  x_bin = seq_along(x_breaks)[-length(x_breaks)],
  y_bin = seq_along(y_breaks)[-length(y_breaks)]
) |>
  rowwise() |>
  mutate(
    state_id   = assign_state(
      x = (x_breaks[x_bin] + x_breaks[x_bin + 1]) / 2,
      y = (y_breaks[y_bin] + y_breaks[y_bin + 1]) / 2,
      dt = NA,
      x_breaks = x_breaks,
      y_breaks = y_breaks
    ),
    lane = lane_name(ymin = y_breaks[y_bin], ymax = y_breaks[y_bin + 1])
  ) |>
  ungroup()

# save lookup
saveRDS(states_lookup, here("data/derived/states_lookup.rds"))
