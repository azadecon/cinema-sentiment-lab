#########################################################################################################
#Purpose: to Collect movie metadata (director, boxoffice collection)  for the sample movies
#########################################################################################################


## source helper functions
### director scraper
source("./scripts/00_director_scraper.R")

#########################################################################################################
#Section I: obtain movies director name
#########################################################################################################

library(tidyverse)
library(jsonlite)
library(httr)
library(tools)

# Example dataframe
bolly_direc <- read_csv("./data/clean/bolly_sample_100.csv") %>% select(imdb_id)

# Add director column by mapping over imdb ids
bolly_direc <- bolly_direc %>%
  mutate(director = map_chr(imdb_id, get_director_name))


# Define and create directories once, globally
metadata_dir = "./data/raw/metadata/"
if (!dir.exists(metadata_dir)) dir.create(metadata_dir, recursive = TRUE)

write_csv(bolly_direc, paste0(metadata_dir, "/bolly_direc.csv"))


#########################################################################################################
#Section II: obtain movies boxoffice collection
#########################################################################################################