##### Script t.1: Basic quality checks for events_clean.rds #####
##### last modified date: may 20, 2025
##### Author: Vidal Tinoco

library(testthat)
library(tidyverse)

# Load cleaned data -----
events_clean <- readRDS("../data/derived/events_clean.rds")

# Helper: coordinate columns (x and y) --------
coord_cols_x <- names(events_clean) |>
  keep(~ str_ends(.x, "\\.x$") &&
         str_detect(.x, "location") &&
         is.numeric(events_clean[[.x]]))

coord_cols_y <- names(events_clean) |>
  keep(~ str_ends(.x, "\\.y$") &&
         str_detect(.x, "location") &&
         is.numeric(events_clean[[.x]]))

# Test 1: exactly 34 matches -------
test_that("number of matches is exactly 34", {
  expect_equal(n_distinct(events_clean$match_id), 34)
})

# Test 2: pitch coordinate ranges -------
test_that("all coordinate values lie within 0-120 (x) and 0-80 (y)", {
  
  ## x-coordinates
  for (col in coord_cols_x) {
    bad_vals <- events_clean[[col]] |>
      discard(is.na) |>
      discard(~ dplyr::between(.x, 0, 120))
    expect_true(length(bad_vals) == 0,
                info = paste("x-coord out of range in column:", col))
  }
  
  ## y-coordinates
  for (col in coord_cols_y) {
    bad_vals <- events_clean[[col]] |>
      discard(is.na) |>
      discard(~ dplyr::between(.x, 0, 80))
    expect_true(length(bad_vals) == 0,
                info = paste("y-coord out of range in column:", col))
  }
})

# Test 3: unique event IDs ------
test_that("event IDs are unique", {
  expect_equal(sum(duplicated(events_clean$id)), 0)
})


# How to run the tests ----
# In an interactive R session, execute:
#
#   devtools::test()
#
# devtools will:
#   1. Load your package (or, for a non-package project, source your scripts)
#   2. Discover every file in tests/testthat/
#   3. Execute the expectations and summarise the results.
#
# A successful run prints “✓ | OK” for each test block. Any failures will be
# shown with their informative messages specified in the `info =` argument
# (e.g., column names that violate the coordinate constraints).
