library(testthat)
library(tidyverse)

source("../scripts/02_grids.R")        # provides assign_state() and breaks
source("../scripts/03_transitions.R")  # provides is_transition()

test_that("is_transition() flags the correct events", {
  
  df <- tibble::tribble(
    ~id, ~possession, ~team.id, ~ElapsedTime,
    1,      10,        165,      42.00,   # B04 in possession
    2,      11,        200,      42.80,   # B04 loses the ball
    3,      11,        200,      44.10,   # opponent action   Δt = 1.3
    4,      10,        165,      45.50,   # B04 recovers      Δt = 2.7
    5,      10,        165,      47.20    # after 4 s window
  )
  
  expect_false(is_transition(1, df))   # before the loss
  expect_false(is_transition(2, df))   # the loss itself
  expect_true( is_transition(3, df))   # inside 0-4 window (opponent)
  expect_true( is_transition(4, df))   # recovery ≤ 4 s
  expect_false(is_transition(5, df))   # outside window
})

