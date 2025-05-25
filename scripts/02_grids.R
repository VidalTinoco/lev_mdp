##### Script 2: grids #####
##### last modified date: may 21, 2025
##### Author: Vidal Tinoco

# Libraries -----
library(tidyverse)

# Build the breaks -----

x_breaks <- seq(0, 120, by = 10)      # 13 break points: 12 bands
y_breaks <- c(0, 12, 20, 28, 40, 52, 60, 68, 80)   # 9 break points: 8 lanes

# helper to name Y-lanes -----

lane_name <- function(ymin, ymax) {
  case_when(
    ymax  <= 12  ~ "LW",        # left wing
    ymin >= 68   ~ "RW",        # right wing
    ymin >= 52 & ymax <= 60 ~ "RHS1",
    ymin >= 60 & ymax <= 68 ~ "RHS2",
    ymin >= 12 & ymax <= 20 ~ "LHS1",
    ymin >= 20 & ymax <= 28 ~ "LHS2",
    ymin >= 28 & ymax <= 40 ~ "CL",
    ymin >= 40 & ymax <= 52 ~ "CR",
    TRUE ~ "UNK"
  )
}

# build grid -----

states_lookup <- crossing(
  xmin = head(x_breaks, -1),
  xmax = tail(x_breaks, -1),
  ymin = head(y_breaks, -1),
  ymax = tail(y_breaks, -1)
) |>
  arrange(xmin, ymin) |>
  mutate(
    state_id = row_number(),                             # 1:96
    lane     = lane_name(ymin, ymax),
    col      = sprintf("C%02d", findInterval(xmin, x_breaks)),
    label    = paste(lane, col, sep = "_")
  ) |>
  select(state_id, xmin, xmax, ymin, ymax, label)

# prepend Transition state -----

states_lookup <- tibble(
  state_id = 0,
  xmin     = NA, xmax = NA, ymin = NA, ymax = NA,
  label    = "TRANSITION_0_4s"
) |>
  bind_rows(states_lookup)

states_lookup

# Function assign_state() ----

#' Assign grid state given raw SB coordinates (x,y) and elapsed time since recovery
#'
#' @param x numeric vector  (0–120)
#' @param y numeric vector  (0–80)
#' @param t_since_recovery numeric vector (seconds since ball recovery); 
#'        values <= 4 are mapped to state 0 (Transition).
#' @return integer vector of state_id (0..96) or NA if outside pitch.
#' @details Bins follow the [xmin, xmax) convention
#          (left-closed, right-open). On a boundary,
#          the point is assigned to the lower/left cell.


assign_state <- function(x, y, t_since_recovery = Inf) {
  
  # ensure same length 
  n <- pmax(length(x), length(y), length(t_since_recovery))
  x <- rep_len(x, n); y <- rep_len(y, n); t_since_recovery <- rep_len(t_since_recovery, n)
  
  # helper to locate interval 
  bin_id <- function(v, breaks) {
    # [a, b): rightmost.closed = FALSE
    findInterval(v, breaks,
                 rightmost.closed = FALSE,
                 all.inside       = FALSE)
  }
  
  
  # handle TRANSITION first 
  trans_idx <- which(!is.na(t_since_recovery) & t_since_recovery <= 4)
  out <- rep(NA_integer_, n)
  out[trans_idx] <- 0L
  
  # remaining points 
  rem <- setdiff(seq_len(n), trans_idx)
  
  x_id <- bin_id(x[rem], x_breaks)
  y_id <- bin_id(y[rem], y_breaks)
  
  # invalid (outside pitch) = NA
  bad <- which(x_id == 0 | x_id > 12 | y_id == 0 | y_id > 8)
  if (length(bad)) {
    x_id[bad] <- NA; y_id[bad] <- NA
  }
  
  # translate to state_id (row-major order)
  # formula: (x_bin-1)*8 + y_bin, then +0 because state_ids start at 1
  out[rem] <- (x_id - 1L) * 8L + y_id
  
  # shift by +1 because 0 is reserved for Transition
  out[rem] <- out[rem] + 1L
  
  out
}
