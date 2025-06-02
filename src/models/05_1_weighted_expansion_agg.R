## src/models/05_1_weighted_expansion_agg.R
# Calculate aggregate counts without fully expanding

library(dplyr)
library(tidyr)
library(here)

# plays_dest data (created with 05_inferdestin_stubversion.R)
plays_dest <- readRDS(here("data/derived/plays_dest.rds"))

# lookup 
states_lookup <- readRDS(here("data/derived/states_lookup.rds"))
n_states      <- nrow(states_lookup)
all_states    <- seq_len(n_states)  # 1, 2, ..., n_states

# Count how many moves there are per home state (`start_state`)
count_by_origin <- plays_dest |>
  group_by(start_state) |>
  summarize(n_plays = n(), .groups = "drop")

# Build the aggregate table origin, dest with uniform weight
trans_counts_agg <- count_by_origin |>
  # Cross each origin with all possible destinations
  tidyr::crossing(dest_state = all_states) |>
  # Calculate the total weight for each pair (origin_state to dest_state)
  mutate(total_weight = n_plays * (1 / n_states)) |>
  select(origin_state = start_state, dest_state, total_weight)

# (Optional) Filter rows where total_weight > 0
trans_counts_agg <- trans_counts_agg |> filter(total_weight > 0)

# save output
saveRDS(trans_counts_agg, here("data/derived/trans_counts_agg.rds"))
message("05_1_weighted_expansion_agg.R: trans_counts_agg.rds generated correctly.")
