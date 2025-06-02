## run/02_generate_events_states.R
# This script creates data/derived/events_states.rds from events_clean.rds,
# assigning state_id to the new 8x5 grid.

# libraries
library(dplyr)
library(here)

# load data
events_clean <- readRDS(here("data/derived/events_clean.rds"))

#  Define breajs for 8×5 grid
x_breaks <- seq(0, 1, length.out = 9)   # 8 bins in X
y_breaks <- seq(0, 1, length.out = 6)   # 5 bins in Y

# load assign_state() 
source(here("src/features/utils_states.R"))

# Assign state_id to each event using location.x / location.y
events_states <- events_clean |>
  mutate(
    x_coord = location.x,
    y_coord = location.y
  ) |>
  rowwise() |>
  mutate(
    state_id = assign_state(
      x       = x_coord,
      y       = y_coord,
      dt      = timestamp,
      x_breaks = x_breaks,
      y_breaks = y_breaks
    )
  ) |>
  ungroup()

# save output
saveRDS(events_states, here("data/derived/events_states.rds"))
message("events_states.rds created correctly with 8×5 grid")
