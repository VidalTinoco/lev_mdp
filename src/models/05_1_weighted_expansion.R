## src/models/05_1_weighted_expansion.R
# Weighted expansion for Bayesian counts

# Libraries
library(dplyr)
library(tidyr)
library(purrr)
library(here)

# Load destiny utilities
source(here("src/models/utils_dest.R"))

# load plays_dest 
plays_dest <- readRDS(here("data/derived/plays_dest.rds"))

# Expand dest_probs into individual rows with end_state and weight columns
trans_counts <- expand_with_weights(plays_dest)

# Save output
saveRDS(trans_counts, here("data/derived/trans_counts.rds"))

message("05_1_weighted_expansion.R: trans_counts.rds generated correctly.")
