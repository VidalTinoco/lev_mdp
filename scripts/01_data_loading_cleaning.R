##### Script 1: data loading and cleaning #####
##### last modified date: may 20, 2025
##### Author: Vidal Tinoco


# Libraries -----
library(tidyverse)
library(jsonlite)


#  Load RDS and list available data frames -----

## Locate RDS files 

rds_files <- list.files(
  path   = "data/raw",
  pattern = "\\.rds$",
  full.names = TRUE,
  ignore.case = TRUE
)

## Load, assign, and display abbreviated glimpse

info_df <- purrr::map_df(rds_files, function(f) {
  
  # object name
  obj_name <- tools::file_path_sans_ext(basename(f))
  
  # read RDS
  obj <- readRDS(f)
  
  # assign to the globalenv
  assign(obj_name, obj, envir = .GlobalEnv)
  
  # glimpse
  cat("\n---", obj_name, "---\n")
  glimpse(select(obj, seq_len(min(5, ncol(obj)))))
  
  # summary
  tibble(
    obj_name = obj_name,
    n_rows   = nrow(obj),
    n_cols   = ncol(obj)
  )
})

## summary table
info_df


# Basic check of events -----

all_na <- function(x) all(is.na(x))

## Name of our own team 
own_team <- "Bayer Leverkusen"

## Confirm 34 matches and list opponents 
match_info <- StatsbombData360 |>
  distinct(match_id, team.name) |>
  group_by(match_id) |>
  summarise(opponent = setdiff(team.name, own_team)) |>
  ungroup()

print(match_info)

stopifnot(nrow(match_info) == 34)  # should be exactly 34 

## Duplicated IDs 
dup_events <- StatsbombData |> 
  summarise(n_dup = sum(duplicated(id))) # 0

dup_events360 <- StatsbombData360 |> 
  summarise(n_dup = sum(duplicated(id))) # 0


## Check critical columns 

critical_cols <- c("location", "pass.end_location", "shot.statsbomb_xg", "counterpress")

crit_check <- map_dfc(
  critical_cols,
  \(col) StatsbombData360 |> 
    summarise("{col}_all_na" := all_na(.data[[col]]))
)

## Overview 

overview_tbl <- tibble(
  dataset = c("StatsbombData", "StatsbombData360"),
  n_rows = c(nrow(StatsbombData),   nrow(StatsbombData360)),
  n_cols = c(ncol(StatsbombData),   ncol(StatsbombData360)),
  n_matches = c(n_distinct(StatsbombData$match_id),
                    n_distinct(StatsbombData360$match_id)),
  n_duplicates = c(dup_events$n_dup,   dup_events360$n_dup)
) |>
  bind_cols(crit_check)   # append *_all_na flags

print(overview_tbl)  


# Check 360 data -----


## Helper: does a row have a non-empty freeze_frame? 

has_freeze <- function(x) {
  # TRUE if list/data.frame column is non-NULL and not just NA
  !(is.null(x) || (length(x) == 1 && is.na(x)))
}

## Overall coverage 
events360_ff <- StatsbombData360 |>
  mutate(has_ff = purrr::map_lgl(freeze_frame, has_freeze))

overall_pct <- mean(events360_ff$has_ff) * 100
cat(sprintf("Overall 360-frame coverage: %.1f%%\n", overall_pct))

## Coverage by event type 
wanted_types <- c("Pass", "Carry", "Shot", "Duel")

coverage_by_type <- events360_ff |>
  filter(type.name %in% wanted_types) |>
  group_by(type.name) |>
  summarise(
    n_events = n(),
    covered  = sum(has_ff),
    pct      = round(100 * covered / n_events, 1),
    .groups  = "drop"
  )

print(coverage_by_type)

## Bar plot 
plot_cov <- coverage_by_type |>
  ggplot(aes(x = reorder(type.name, pct), y = pct)) +
  geom_col(fill = "#418fde") +
  geom_text(aes(label = sprintf("%.1f%%", pct)), vjust = -0.3, size = 3.5) +
  labs(
    x = NULL, y = "360-frame coverage (%)",
    title = "StatsBomb 360 Frame Coverage by Event Type"
  ) +
  ylim(0, 100) +
  theme_minimal(base_size = 12)

## Ensure folder exists and save
ggsave("outputs/coverage_360.png", plot_cov, width = 6, height = 4, dpi = 300)


# Column normalization and debugging -----
