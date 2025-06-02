## src/io/utils.R
# Data loading and cleaning utilities

# Libraries
library(dplyr)
library(stringr)

# all_na: removes columns composed entirely of NA
all_na <- function(df) {
  df |> 
    select(!where(~ all(is.na(.))))
}

# has_freeze: detects the presence of freeze-frames
has_freeze <- function(df) {
  if ("freeze_frame" %in% names(df)) {
    any(df$freeze_frame == TRUE, na.rm = TRUE)
  } else {
    FALSE
  }
}

# scale_if_needed: If the coordinates exceed [0,1], assume they are at [0,100] and scale to [0,1]
scale_if_needed <- function(df) {
  if (all(c("x", "y") %in% names(df))) {
    if (max(df$x, na.rm = TRUE) > 1 || max(df$y, na.rm = TRUE) > 1) {
      df <- df |> 
        mutate(
          x = x / 100,
          y = y / 100
        )
    }
  }
  df
}
