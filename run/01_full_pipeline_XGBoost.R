## run/01_full_pipeline_light.R
# Launcher that executes the entire pipeline for XGBoost, reducing memory usage

# libraries
library(here)

# Helper to run Rscript commands and stop if it fails
run_step <- function(cmd) {
  cat("Running: ", cmd, "\n")
  code <- system(cmd)
  if (code != 0) {
    stop("ERROR in step: ", cmd)
  }
}

# Steps

run_step("Rscript src/io/01_data_loading_cleaning.R") # events_clean.rds

run_step("Rscript src/features/02_grids.R") # states_lookup.rds (8×5)

run_step("Rscript run/02_generate_events_states.R") # events_states.rds

run_step("Rscript src/features/03_transitions.R") # (optional) transitions

run_step("Rscript run/03_generate_plays.R") # plays.rds

run_step("Rscript src/models/train_xgb_dest.R") # model XGBoost

run_step("Rscript src/models/05_inferdestin_batched.R") # plays_dest.rds

run_step("Rscript src/models/05_1_weighted_expansion_agg.R")  # trans_counts_agg.rds

cat("Pipeline completed without errors.\n")
