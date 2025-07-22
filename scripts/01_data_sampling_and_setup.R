#########################################################################################################
#Purpose: to obtain and create random sample of 100 movies
#########################################################################################################

#########################################################################################################
#Section I: obtain movies dataset
#########################################################################################################

# Set up: Ensure kaggle.json (downloaded from Kaggle site) is placed correctly for authentication

kaggle_dir <- file.path(Sys.getenv("USERPROFILE"), ".kaggle")
if (!dir.exists(kaggle_dir)) dir.create(kaggle_dir)

# Replace this path if kaggle.json is stored elsewhere
file.copy("../kaggle.json", file.path(kaggle_dir, "kaggle.json"), overwrite = TRUE)

# Set environment variable for Kaggle CLI to find kaggle.json
Sys.setenv(KAGGLE_CONFIG_DIR = kaggle_dir)

# Load required R packages
library(tidyverse)
library(reticulate)

# Install and load Kaggle Python package
reticulate::py_install("kaggle", pip = TRUE)
kaggle <- import("kaggle")  # optional: not needed for system2 method

# Create output directory for data
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)

# Download and unzip dataset using system2 (calls Kaggle CLI)
system2("kaggle", args = c(
  "datasets", "download",
  "-d", "pncnmnp/the-indian-movie-database",
  "--unzip",
  "-p", "data/raw"
))

#########################################################################################################
#Section II: Sample movies
#########################################################################################################

################
# DATA LOADING #
################

# Directory containing the files
post_2010_data_dir <- "./data/raw/2010-2019"

# Map of informative object names to filenames
file_map <- c(
  bolly_main    = "bollywood_2010-2019.csv",
  bolly_meta    = "bollywood_meta_2010-2019.csv",
  bolly_ratings = "bollywood_ratings_2010-2019.csv",
  bolly_text    = "bollywood_text_2010-2019.csv"
)

# Read all files into a named list
bolly_list <- map(file_map, ~ read_csv(file.path(post_2010_data_dir, .x)))

# Optionally assign to individual objects in global environment
list2env(bolly_list, envir = .GlobalEnv)

################
# DATA MERGING #
################

set.seed(1234)

# since we expect missing `year_of_release`, missing Wikipedia links, we sample only on those with available values.
# we first join bolly_meta which has `year_of_release` with bolly_main which has `wiki_link`

# Step 1a: ensure unique imdb_id, Join metadata with wiki link info
bolly_year_link <- bolly_meta %>%
  mutate(year_of_release = as.numeric(year_of_release)) %>%
  add_count(imdb_id) %>%
  filter(n == 1) %>%  # keep only imdb_ids that appear once
  select(-n) %>%
  left_join(bolly_main, by = "imdb_id")

# Step 1b: Filter to valid year and non-missing wiki_link
bolly_year_link_valid <- bolly_year_link %>%
  filter(!is.na(year_of_release), year_of_release > 2010,
         !is.na(wiki_link), wiki_link != "")

# Step 2: Merge ratings and text data
bolly_all_valid <- bolly_year_link_valid %>%
  left_join(bolly_ratings, by = "imdb_id") %>%
  left_join(bolly_text,    by = "imdb_id")


# Step 3: Randomly sample 100
bolly_sample_100 <- bolly_all_valid %>%
  slice_sample(n = 100)

# clean column names
bolly_sample_100 <- bolly_sample_100 %>% 
  select(-title.y) %>% 
  rename("title" = "title.x")

# ensure that the merge went correctly
stopifnot(nrow(bolly_all_valid) == n_distinct(bolly_all_valid$imdb_id))

dir.create("data/clean", recursive = TRUE, showWarnings = FALSE)
write_csv(bolly_sample_100, "./data/clean/bolly_sample_100.csv")






























