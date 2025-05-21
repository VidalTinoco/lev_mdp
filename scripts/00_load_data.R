##### Script 0: get the data #####
##### Retrieved from: https://statsbomb.com/articles/soccer/free-statsbomb-data-bayer-leverkusens-invincible-bundesliga-title-win/
##### last modified date: may 20, 2025
##### Author: Vidal Tinoco

# libraries
library(tidyverse)
library(StatsBombR)
library(here)


# get matches data
Comp <- FreeCompetitions() %>%
  filter(competition_id=="9" & season_id=="281")

Matches <- FreeMatches(Comp)

StatsbombData <- free_allevents(MatchesDF = Matches, Parallel = T)

StatsbombData = allclean(StatsbombData)

# add 360 data:

data_360 <- free_allevents_360(MatchesDF = Matches, Parallel = T)

data_360 = data_360 %>% rename(id = event_uuid)

StatsbombData360 = StatsbombData %>% left_join(data_360, by = c("id" = "id"))

StatsbombData360 = StatsbombData360 %>% rename(match_id = match_id.x) %>% select(-match_id.y)

# save them on RDS format

## create directory
dir.create("data/raw", showWarnings = FALSE, recursive = TRUE)

## get dataframes
dataframes <- ls()[sapply(ls(), function(x) {
  obj <- get(x, envir = .GlobalEnv)
  is.data.frame(obj) || inherits(obj, "tbl_df")
})]

dataframes

## save them
for (name in dataframes) {
  df <- get(name, envir = .GlobalEnv) 
  
  saveRDS(df, file = paste0("data/raw/", name, ".rds"))
  
  cat(paste("Saved", name, " RDS format\n"))
}
