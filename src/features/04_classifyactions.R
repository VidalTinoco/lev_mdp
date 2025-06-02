## src/features/04_classifyactions.R
# classify actions 


# libraries
library(dplyr)
library(here)

# load utilities
source(here("src/features/02_grids.R"))          # assign_state()
source(here("src/features/03_transitions_clf.R"))  # is_transition_vec() and is_transition()

classify_actions <- function(events_df,
                             focal_team = 165,
                             window_secs = 4) {
  
  # Sort chronologically
  events_df <- events_df |>
    arrange(match_id, period, index) |>
    
    # Label change of possession (gegenpress window)
    mutate(
      transition_flag = is_transition_vec(
        team.id, 
        ElapsedTime,
        focal_team  = focal_team,
        window_secs = window_secs
      ),
      
      # Assign start state
      start_state = assign_state(
        x = location.x,
        y = location.y,
        dt = ElapsedTime,
        x_breaks = seq(0, 1, length.out = 13),
        y_breaks = seq(0, 1, length.out = 8)
      ),
      
      # set end status:
      # - If it's a pass (type.name == "Pass")
      # - Otherwise, we keep the same state as the start state
      end_state = case_when(
        type.name == "Pass" & !is.na(pass.end_location.x) ~ 
          assign_state(
            x = pass.end_location.x,
            y = pass.end_location.y,
            dt = ElapsedTime,
            x_breaks = seq(0, 1, length.out = 13),
            y_breaks = seq(0, 1, length.out = 8)
          ),
        TRUE ~ start_state
      )
    )
  
  events_df
}
