## src/models/05_inferdestin_batched.R
# Infer destinations in batches to reduce memory usage

# libraries
library(dplyr)
library(purrr)
library(xgboost)
library(here)

# load data and models
plays            <- readRDS(here("data/derived/plays.rds"))
events           <- readRDS(here("data/derived/events_clean.rds"))
states_lookup    <- readRDS(here("data/derived/states_lookup.rds"))
xgb_model        <- xgb.load(here("models/xgb_dest_model.xgb"))

# grid parameters
x_breaks <- seq(0, 1, length.out = 9)
y_breaks <- seq(0, 1, length.out = 6)

n_states <- nrow(states_lookup)
n_total  <- nrow(plays)
batch_sz <- 2000
n_batches <- ceiling(n_total / batch_sz)

# Function to extract features from a block of moves
extract_features_block <- function(block_df) {
  block_df |>
    mutate(
      angle    = atan2(pass.end_location.y - location.y,
                       pass.end_location.x - location.x),
      dist     = sqrt((pass.end_location.x - location.x)^2 +
                        (pass.end_location.y - location.y)^2),
      log_dist = log(dist + 1),
      origin_cell = start_state
    ) |>
    select(origin_cell, angle, log_dist)
}

# loop blocks
plays_dest_list <- vector("list", n_batches)

for (b in seq_len(n_batches)) {
  i1 <- (b - 1) * batch_sz + 1
  i2 <- min(b * batch_sz, n_total)
  block <- plays[i1:i2, ]
  
  # Extract features and create DMatrix
  feats_block <- extract_features_block(block)
  dmat        <- xgb.DMatrix(data = as.matrix(feats_block |> select(-origin_cell)))
  
  # Predict probabilities (long vector)
  probs_vec <- predict(xgb_model, dmat)
  
  # Convert to matrix (n_rows x n_states)
  mat_block <- matrix(probs_vec, ncol = n_states, byrow = TRUE)
  
  # Attach dest_probs column (list of vectors)
  block$dest_probs <- split(mat_block, seq_len(nrow(mat_block)))
  
  plays_dest_list[[b]] <- block
  rm(block, feats_block, dmat, mat_block, probs_vec)
  gc()
}

# join blocks and save output
plays_dest <- bind_rows(plays_dest_list)
saveRDS(plays_dest, here("data/derived/plays_dest.rds"))
message("05_inferdestin_batched.R: plays_dest.rds generated in ", n_batches, " batches.")
