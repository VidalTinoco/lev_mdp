library(testthat)
library(tidyverse)

# load helpers 
source("../scripts/02_grids.R")         #  assign_state()
source("../scripts/03_transitions.R")   #  is_transition_vec()  / is_transition()
source("../scripts/04_classifyactions.R")   #  classify_actions()

test_that("classify_actions() returns correct MDP labels and states", {
  
  toy <- tibble::tribble(
    ~id, ~match_id, ~period, ~index,
    ~team.id, ~possession, ~ElapsedTime,
    ~type.name, ~Pass.type.name, ~outcome, ~shot.outcome.name,
    ~location.x, ~location.y, ~end_location.x, ~end_location.y,
    
    # 1) Successful pass  (Bayer 04 in possession)
    1, 1, 1, 1,
    165, 10, 40.00,
    "Pass", NA, "Complete", NA,
    40, 25, 50, 30,
    
    # 2) Failed pass  -> loss of possession
    2, 1, 1, 2,
    200, 11, 40.80,
    "Pass", NA, "Incomplete", NA,
    50, 30, 60, 40,          # ← faltaban estos cuatro valores
    
    # 3) Opponent action inside gegenpress window  (Δt = 1.3)
    3, 1, 1, 3,
    200, 11, 42.10,
    "Pass", NA, "Complete", NA,
    55, 35, 60, 35,
    
    # 4) B04 recovers inside window (Δt = 2.7)
    4, 1, 1, 4,
    165, 10, 43.50,
    "Dribble", NA, "Complete", NA,
    60, 35, 68, 35,
    
    # 5) Shot -> GOAL   (still same possession)
    5, 1, 1, 5,
    165, 10, 44.90,
    "Shot", NA, NA, "Goal",
    88, 12, 90,  8
  )
  
  out <- classify_actions(toy)
  
  # check MDP classes 
  expect_equal(out$action_mdp,
               c("move", "lost_possession",
                 "move", "move",
                 "goal"))
  
  # check that Transition overrides spatial state 
  # event 3 and 4 occur inside the 0-4 s gegenpress window then start_state == 0
  expect_equal(out$start_state[3:4], c(0L, 0L))
  
  # event 1: pass from 40,25 to 50,30
  s1  <- assign_state(40, 25, Inf)
  e1  <- assign_state(50, 30, Inf)
  expect_equal(out$start_state[1], s1)
  expect_equal(out$end_state  [1], e1)
  
  # event 2: failed pass to end_state must be NA + lost_possession
  expect_true(is.na(out$end_state[2]))
  
  # event 5: goal is absorbing - same start / end state
  expect_equal(out$start_state[5], out$end_state[5])
  
  # all rows keep order and no NAs in action_mdp 
  expect_equal(out$id, toy$id)
  expect_false(any(is.na(out$action_mdp)))
})
