## src/features/03_transitions_clf.R

# libraries
library(dplyr)
library(tidyverse)

# is_transition_vec: Vectorised version to detect recovery of possession
is_transition_vec <- function(team_id,
                              elapsed,
                              focal_team = 165,
                              window_secs = 4) {
  
  # logical indices where the focal team loses possession
  lost_idx <- which(
    dplyr::lag(team_id, default = team_id[1]) == focal_team &
      team_id != focal_team
  )
  
  flag <- rep(FALSE, length(team_id))
  
  for (i in lost_idx) {
    # search window from i to i+window_secs (based on elapsed)
    end_time  <- elapsed[i] + window_secs
    next_idx  <- which(elapsed > elapsed[i] & elapsed <= end_time)
    # mark transitions if the team regains possession
    if (any(team_id[next_idx] == focal_team)) {
      flag[next_idx[1]] <- TRUE
    }
  }
  flag
}

# is_transition: wrapper to use in mutate(rowwise)
is_transition <- function(i,
                          df,
                          team_id = 165,
                          window  = 4) {
  if (i <= 1) return(FALSE)
  flag_vec <- is_transition_vec(df$team.id,
                                df$ElapsedTime,
                                focal_team = team_id,
                                window_secs = window)
  flag_vec[i]
}
