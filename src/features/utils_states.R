## src/features/utils_states.R
# Utilities for state assignment and transition detection

# Libraries
library(dplyr)

# lane_name: Y-band labeling according to ymin and ymax
lane_name <- function(ymin, ymax) {
  paste0("lane_", floor(ymin * 3) + 1)
}

# bin_id: assign bin id in X or Y based on break vectors
bin_id <- function(coord, breaks) {
  findInterval(coord, breaks, all.inside = TRUE)
}

# assign_state: returns unique state_id from coordinates and timestamp
assign_state <- function(x, y, dt, x_breaks, y_breaks) {
  x_bin <- bin_id(x, x_breaks)
  y_bin <- bin_id(y, y_breaks)
  state_id <- (y_bin - 1) * (length(x_breaks) - 1) + x_bin
  state_id
}

# is_transition_vec: vectorized to mark transitions between states
is_transition_vec <- function(states) {
  c(FALSE, diff(states) != 0)
}

# is_transition: for a single pair of states
is_transition <- function(prev_state, curr_state) {
  prev_state != curr_state
}
