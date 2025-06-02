## src/models/utils_dest.R
# Utilities for destination inference and weight expansion

# Libraries
library(dplyr)
library(tidyr)
library(purrr)
library(xgboost)

# closest_teammate_cell: returns the state_id of the closest teammate to the passing vector
closest_teammate_cell <- function(event_row, teammate_positions, states_lookup, x_breaks, y_breaks) {
  # Calculate perpendicular distance to the pass vector
  dists <- purrr::map_dbl(teammate_positions, ~ dist_line_to_point(.x, list(x = event_row$x_end, y = event_row$y_end), list(x = event_row$x_start, y = event_row$y_start)))
  closest_idx <- which.min(dists)
  
  #Extract coordinates of the nearest teammate
  pos <- teammate_positions[[closest_idx]]
  assign_state(pos$x, pos$y, event_row$timestamp, x_breaks, y_breaks)
}

# dist_line_to_point: perpendicular distance from a point to the pass line
# pt: point (teammate), start: start of the pass, end: end of the pass
dist_line_to_point <- function(pt, start, end) {
  num <- abs((end$y - start$y) * pt$x - (end$x - start$x) * pt$y + end$x * start$y - end$y * start$x)
  den <- sqrt((end$y - start$y)^2 + (end$x - start$x)^2)
  num / den
}

# extract_features: build features for XGBoost from a play queue
# Must return a data.frame or vector with columns: origin_cell, angle, log_dist, last3_actions
# adjust
extract_features <- function(play_row, events) {
  # Example:
  
  # origin_cell <- play_row$state_start
  
  # angle <- atan2(play_row$y_end - play_row$y_start, play_row$x_end - play_row$x_start)
  
  # log_dist <- log(sqrt((play_row$x_end - play_row$x_start)^2 + (play_row$y_end - play_row$y_start)^2) + 1)
  
  # last3_actions <- events |> filter(match_id == play_row$match_id & timestamp < play_row$timestamp) |> tail(3) |> pull(event_type)
  
  # data.frame(state_id = origin_cell, angle = angle, log_dist = log_dist, a1 = last3_actions[1], a2 = last3_actions[2], a3 = last3_actions[3])
  stop("Define extract_features() according to your data structure")
}

# xgb_probs: uses pre-trained XGBoost model to predict probabilities
eval_xgb_probs <- function(features, xgb_model) {
  dmatrix <- xgb.DMatrix(data = as.matrix(features))
  probs <- predict(xgb_model, dmatrix)
  probs_mat <- matrix(probs, ncol = ncol(states_lookup), byrow = TRUE)
  probs_mat
}

# infer_destinations: main function to infer destinations of failed passes
infer_destinations <- function(plays, events, states_lookup, xgb_model, x_breaks, y_breaks, teammate_positions_list) {
  plays |>
    rowwise() |> 
    mutate(
      dest_probs = list(
        if (!is.na(first(events$freeze_frame))) {
          # Case with 360 frame
          closest_state <- closest_teammate_cell(cur_data(), teammate_positions_list[[cur_group_id()]], states_lookup, x_breaks, y_breaks)
          probs <- rep(0, nrow(states_lookup)); probs[closest_state] <- 1; probs
        } else {
          # Frameless case: use XGBoost
          feats <- extract_features(cur_data(), events)
          probs <- as.numeric(eval_xgb_probs(feats, xgb_model))
          probs
        }
      )
    ) |> 
    ungroup()
}

# expand_with_weights: unnested dest_probs into rows with state_id and weight
expand_with_weights <- function(plays_dest) {
  plays_dest |>
    unnest_wider(dest_probs, names_sep = "_") |>
    pivot_longer(cols = starts_with("dest_probs_"),
                 names_to = "end_state", values_to = "weight") |>
    mutate(end_state = as.integer(sub("dest_probs_", "", end_state)))
}
