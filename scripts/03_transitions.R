##### Script 3: transitions #####
##### last modified date: may 24, 2025
##### Author: Vidal Tinoco

library(tidyverse)

# Is transition - Vectorised version 
is_transition_vec <- function(team_id,
                              elapsed,
                              focal_team   = 165,   # B04
                              window_secs  = 4) {
  
  # logical indices where possession is lost by focal team
  lost_idx <- which(
    dplyr::lag(team_id, default = team_id[1]) == focal_team &
      team_id != focal_team
  )
  
  # propagate last loss index forward
  last_loss <- rep(NA_integer_, length(team_id))
  last_loss[lost_idx] <- lost_idx
  last_loss <- tidyr::fill(tibble(last_loss), last_loss, .direction = "down")$last_loss
  
  dt <- elapsed - elapsed[last_loss]
  flag <- dt > 0 & dt <= window_secs
  flag[is.na(flag)] <- FALSE
  flag
}

# Row-wise wrapper (keeps API used in tests) 
is_transition <- function(i,
                          df,
                          team_id = 165,
                          window  = 4) {
  
  if (i <= 1) return(FALSE)
  
  flag_vec <- is_transition_vec(df$team.id, df$ElapsedTime,
                                focal_team  = team_id,
                                window_secs = window)
  flag_vec[i]
}
