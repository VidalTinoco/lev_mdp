## src/io/01_data_loading_cleaning.R
# Loading RDS and cleaning utilities

# libraries
library(dplyr)
library(here)
library(jsonlite)
library(readr)

# Load cleaning utilities
source(here("src/io/utils.R"))

# Loading raw RDS files
event_files <- list.files(here("data/raw"), pattern = "*.rds$", full.names = TRUE)
events_list <- lapply(event_files, readRDS)
df_raw <- bind_rows(events_list)

# clean dataframe
df_clean <- df_raw |> 
  all_na() |>             # removes all NA columns
  scale_if_needed()       # rescale coordinates if necessary

# save clean output
write_rds(df_clean, here("data/derived/events_clean.rds"))

message("Finished data loading and cleaning: events_clean.rds created.")
