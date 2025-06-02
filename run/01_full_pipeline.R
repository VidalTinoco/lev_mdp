# 01_full_pipeline.R 
library(tidyverse)
library(here)

# load clean data
events <- readRDS(here("data/derived/events_clean.rds"))

# load functions
source(here("scripts/grid.R"))               # states_lookup, assign_state()
source(here("scripts/04_classifyactions.R"))   # classify_actions()
source(here("scripts/05_inferdestin.R")) # infer_destinations()
source(here("scripts/05_01_weighted_expansion.R")) # expand_with_weights()

# classify plays
plays <- classify_actions(events, states_lookup)

# infer destinations
plays_dest <- infer_destinations(plays, events, states_lookup)

# expand with weights
trans_counts <- expand_with_weights(plays_dest)

# save results for bayes
dir.create(here("data/derived"), showWarnings = FALSE, recursive = TRUE)
saveRDS(plays_dest   , here("data/derived/plays_dest.rds"))
saveRDS(trans_counts , here("data/derived/trans_counts.rds"))

cat("Pipeline done \n")
