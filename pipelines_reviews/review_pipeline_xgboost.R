library(here)
library(dplyr)

# Check states_lookup.rds (must have 40 rows for 8x5 grid)
sl <- readRDS(here("data/derived/states_lookup.rds"))
cat("states_lookup:\n")
print(sl)
cat("Rows:", nrow(sl), "   Columns:", ncol(sl), "\n\n")

# Check events_states.rds: verify that it exists and has a state_id column in [1,40]
es <- readRDS(here("data/derived/events_states.rds"))
cat("events_states:\n")
cat("Rows:", nrow(es), "   Columns:", ncol(es), "\n")
cat("Range of state_id:", range(es$state_id, na.rm = TRUE), "\n\n")

# Check plays.rds: it should have columns start_state, end_state, transition_flag
pl <- readRDS(here("data/derived/plays.rds"))
cat("plays:\n")
cat("Rows:", nrow(pl), "   Columns:", ncol(pl), "\n")
cat("Range of start_state:", range(pl$start_state, na.rm = TRUE), "\n")
cat("Range of end_state:", range(pl$end_state, na.rm = TRUE), "\n")
cat("Head:\n")
print(head(pl, 5))
cat("\n")

# Review XGBoost model: load .rds and display basic parameters
model <- readRDS(here("models/xgb_dest_model.rds"))
cat("Model XGBoost loaded.\n")
cat("num_class =", model$params$num_class, "\n\n")

# Check plays_dest.rds: contains dest_probs (lists of length 40)
pd <- readRDS(here("data/derived/plays_dest.rds"))
cat("plays_dest:\n")
cat("Rows:", nrow(pd), "   Columns:", ncol(pd), "\n")
# Check a random row
i <- sample(seq_len(nrow(pd)), 1)
probs_i <- pd$dest_probs[[i]]
cat("Length of dest_probs in row", i, ":", length(probs_i), "\n")
cat("Sum of dest_probs in that row:", sum(probs_i), "\n\n")

# Check trans_counts_agg.rds: must have rows <= 40×40
tc <- readRDS(here("data/derived/trans_counts_agg.rds"))
cat("trans_counts_agg:\n")
cat("Rows:", nrow(tc), "   Columns:", ncol(tc), "\n")
cat("Head:\n")
print(head(tc, 10))
cat("\n")

# Overview of total weights by origin:
summary_by_origin <- tc |>
  group_by(origin_state) |>
  summarize(total_weight = sum(total_weight)) |>
  arrange(origin_state)
cat("Summation of total_weight by origin_state (first 10):\n")
print(head(summary_by_origin, 10))
cat("\n")
