## src/models/05_inferdestin.R
# Inferring destinations from failed passes (Stub version, without model)

# Libraries
library(dplyr)
library(tidyr)
library(purrr)
library(here)

# Load destiny utilities (contains expand_with_weights but not infer_destinations, in this version we stub it manually)
source(here("src/models/utils_dest.R"))

# STUB: Directly generate uniform probabilities per state

# Number of states from states_lookup (will be loaded later) (Leave NULL here to define it after loading states_lookup)
n_states <- NULL

# Define function that returns uniform vector (without using events or xgb_model)
generate_uniform_probs <- function() {
  rep(1 / n_states, n_states)
}

# Load data

# plays: object resulting from classify_actions
plays <- readRDS(here("data/derived/plays.rds"))

# We don't need to use events in the stub, we omit it
# states_lookup: cell lookup (to know n_states)
states_lookup <- readRDS(here("data/derived/states_lookup.rds"))
n_states <- nrow(states_lookup)

# x_breaks and y_breaks (they are not used in stub but we define them for compatibility)
x_breaks <- seq(0, 1, length.out = 13)
y_breaks <- seq(0, 1, length.out = 8)

# teammate_positions_list (not used in stub)
teammate_positions_list <- vector("list", nrow(plays))

# Create plays_dest with uniform probabilities
plays_dest <- plays |>
  rowwise() |>
  mutate(
    # Generates a list of uniform probabilities for each row
    dest_probs = list(generate_uniform_probs())
  ) |>
  ungroup()

#Save output
saveRDS(plays_dest, here("data/derived/plays_dest.rds"))
message("05_inferdestin.R (stub): plays_dest.rds generated with uniform probabilities.")
