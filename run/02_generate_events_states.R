## run/02_generate_events_states.R
# This script creates data/derived/events_states.rds from events_clean.rds
# (assigning each event its state_id based on location.x, location.y)

# Libraries
library(dplyr)
library(here)

# Load data
events_clean <- readRDS(here("data/derived/events_clean.rds"))

# breaks
x_breaks <- seq(0, 1, length.out = 13)
y_breaks <- seq(0, 1, length.out = 8)

# load assign_state() 
source(here("src/features/utils_states.R"))

# Assign state_id to each event using location.x, location.y
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
message("events_states.rds created correctly.")
