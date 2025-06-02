## src/features/03_transitions.R
# Detecting transitions between states

# Libraries
library(dplyr)
library(here)

# Load states utilities
source(here("src/features/utils_states.R"))

# Load data from (previously assigned) states
df_states <- readRDS(here("data/derived/events_states.rds"))

# Mark transitions
df_states <- df_states |>
  arrange(match_id, period, timestamp) |>
  group_by(match_id, period) |>
  mutate(
    transition_flag = is_transition_vec(state_id)
  ) |>
  ungroup()

# save output
saveRDS(df_states, here("data/derived/events_transitions.rds"))
