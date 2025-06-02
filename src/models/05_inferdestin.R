## src/models/05_inferdestin.R
# Inferring destinations from failed passes

# Libraries
library(dplyr)
library(tidyr)
library(purrr)
library(xgboost)
library(here)

# Load destiny utilities
source(here("src/models/utils_dest.R"))

# Load data
# - plays: object resulting from classify_actions (with columns state_start, x_start, y_start, x_end, y_end, match_id, timestamp, freeze_frame, etc.)
# - events: complete event dataframe with 360 frames of information (to detect freeze_frames and last actions)
# - states_lookup: cell lookup 
# - xgb_model: pre-trained XGBoost model (.xgb or .rds file)
# - x_breaks, y_breaks: break vectors for state grid
# - teammate_positions_list: list of teammate positions per play

# adjust routes:
plays      <- readRDS(here("data/derived/plays.rds"))
events     <- readRDS(here("data/derived/events_clean.rds"))
states_lookup <- readRDS(here("data/derived/states_lookup.rds"))

# Example of loading an XGBoost model (can be a model saved with xgb.save or saveRDS)
# Set "models/xgb_dest_model.xgb" to the actual path of your model:
xgb_model <- xgb.load(here("models/xgb_dest_model.xgb"))

# x_breaks and y_breaks must match those used in 02_grids.R:
x_breaks <- seq(0, 1, length.out = 13)
y_breaks <- seq(0, 1, length.out = 8)

# Build teammate_positions_list
# Define a function or logic that, for each row of plays, extracts the (x,y) coordinates of the teammates.
# For now, this is an example: an empty list to illustrate the syntax.
# Later, replace it with get_player_positions(...)
teammate_positions_list <- vector("list", nrow(plays))

# Example (pseudocode):
# for(i in seq_len(nrow(plays))) {
# this_play <- plays[i, ]
# mx_id <- this_play$match_id
# period <- this_play$period
# time_stamp <- this_play$timestamp
# # Assuming you have the function get_player_positions(match_id, period, timestamp)
# teammate_positions_list[[i]] <- get_player_positions(mx_id, period, time_stamp)
# }

# Run infer_destinations for all plays
plays_dest <- infer_destinations(
  plays                   = plays,
  events                  = events,
  states_lookup           = states_lookup,
  xgb_model               = xgb_model,
  x_breaks                = x_breaks,
  y_breaks                = y_breaks,
  teammate_positions_list = teammate_positions_list
)

# Save output
# This object must contain at least the `dest_probs` column (list of probabilities by state_id)
saveRDS(plays_dest, here("data/derived/plays_dest.rds"))

message("05_inferdestin.R: plays_dest.rds generated correctly.")
