library(testthat)
source("../scripts/02_grids.R")  

test_that("centre of each cell maps to its own state_id", {
  for (i in 1:12) {
    for (j in 1:8) {
      cx <- mean(x_breaks[i:(i+1)])
      cy <- mean(y_breaks[j:(j+1)])
      expect_equal(assign_state(cx, cy, 10), (i-1)*8 + j + 1)   # +1 for Transition
    }
  }
})

test_that("border points land in the LOWER/LEFT cell", {
  expected <- (2 - 1) * 8 + 2 + 1          
  
  expect_equal(assign_state(10, 12), expected)
  
})


test_that("Transition overrides spatial lookup", {
  expect_equal(assign_state(60, 40, 2), 0)     # inside CL, but within 4 s
})

test_that("out-of-pitch returns NA", {
  expect_true(is.na(assign_state(-5, 30)))
  expect_true(is.na(assign_state(30, 85)))
})

test_that("assign_state() vectoriza correctamente", {
  xs <- c(5, 55, -3, 115)
  ys <- c(6, 30, 40, 81)
  ts <- c(10, 1,  6,  10)
  out <- assign_state(xs, ys, ts)
  expect_equal(out[2], 0L)       # second point within Transition
  expect_true(is.na(out[3]))     # out the field in X
  expect_true(is.na(out[4]))     # out of the field in Y
})
