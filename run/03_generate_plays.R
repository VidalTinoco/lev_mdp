## run/03_generate_plays.R
# This script creates data/derived/plays.rds using classify_actions()

# Libraries
library(dplyr)
library(here)

# Load data
events_clean  <- readRDS(here("data/derived/events_clean.rds"))
states_lookup <- readRDS(here("data/derived/states_lookup.rds"))

# load classify_actions()
source(here("src/features/04_classifyactions.R"))

# run classify_actions
plays <- classify_actions(
  events_df   = events_clean,
  focal_team  = 165,
  window_secs = 4
)

# save output
saveRDS(plays, here("data/derived/plays.rds"))
message("plays.rds created correctly.")
