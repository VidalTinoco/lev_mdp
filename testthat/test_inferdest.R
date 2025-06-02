library(testthat)
source("scripts/05_inferdestin.R")

test_that("infer_destinations() combines 360 and XGBoost correctly", {
  
  # --- mock objects ------------------------------------------------------
  grid <- tibble::tibble(state_id = 1:3)          # dummy grid
  assign_state <- function(x, y, t) 1L            # always returns 1
  
  # minimal fake model: returns prob = c(0.6, 0.3, 0.1)
  xgb_model <- structure(
    list(),
    class = "dummy_xgb"
  )
  predict.dummy_xgb <- function(object, newdata, type) {
    c("1" = 0.6, "2" = 0.3, "3" = 0.1)
  }
  
  # fake events -----------------------------------------------------------
  ev <- tibble::tibble(
    id            = 1001:1002,
    location.x    = c(40, 40),
    location.y    = c(30, 30),
    end_location.x= c(55, 55),
    end_location.y= c(35, 35)
  )
  
  # 360 only for first event (teammate inside 5 m)
  frames360 <- tibble::tibble(
    event_uuid = 1001,
    location.x = 50,
    location.y = 32,
    teammate   = TRUE
  )
  
  out <- infer_destinations(ev, xgb_model, frames360, grid, top_k = 2)
  
  # ---------------------------------------------------------------
  # expectations
  # ---------------------------------------------------------------
  # Event 1 should yield single-cell distribution of prob 1
  expect_equal(length(out$dest_probs[[1]]), 1)
  expect_equal(unname(out$dest_probs[[1]]), 1)
  # Event 2 falls back to xgboost → two cells
  expect_equal(length(out$dest_probs[[2]]), 2)
  expect_equal(sum(out$dest_probs[[2]]), 1, tolerance = 1e-12)
})
