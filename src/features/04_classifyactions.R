## src/features/04_classifyactions.R
# classify actions 

# libraries
library(dplyr)
library(here)

# load utils
source(here("src/features/02_grids.R"))          # assign_state()  8×5
source(here("src/features/03_transitions_clf.R"))  # is_transition_vec() and is_transition()

classify_actions <- function(events_df,
                             focal_team   = 165,
                             window_secs  = 4) {
  
  # sort chronologically
  events_df <- events_df |>
    arrange(match_id, period, index) |>
    
    # label transition (gegenpress window)
    mutate(
      transition_flag = is_transition_vec(
        team.id, 
        ElapsedTime,
        focal_team  = focal_team,
        window_secs = window_secs
      ),
      # Assign start state: we use location.x / location.y with 8×5 grid
      start_state = assign_state(
        x        = location.x,
        y        = location.y,
        dt       = ElapsedTime,
        x_breaks = seq(0, 1, length.out = 9),    # 8 bins in X
        y_breaks = seq(0, 1, length.out = 6)     # 5 bins in Y
      ),
      
      # Set end state:
      # - If it's a pass (type.name == "Pass"), we use pass.end_location.x / pass.end_location.y
      # - Otherwise, we keep the same state as the start state
      end_state = case_when(
        type.name == "Pass" & !is.na(pass.end_location.x) ~ 
          assign_state(
            x        = pass.end_location.x,
            y        = pass.end_location.y,
            dt       = ElapsedTime,
            x_breaks = seq(0, 1, length.out = 9),    # 8 bins in X
            y_breaks = seq(0, 1, length.out = 6)     # 5 bins in Y
          ),
        TRUE ~ start_state
      )
    )
  
  events_df
}
