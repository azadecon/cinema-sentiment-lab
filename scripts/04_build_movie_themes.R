#############################################################################################################################
## Purpose: to create a build for thematic analysis. It includes relevant columns over and above movie plots and subtitles ##
#############################################################################################################################

###########################
## Step I: Prepare plots ##
###########################

library(tidyverse)
library(jsonlite)
library(stringr)


# bring in relevant columns for the movie sample
bolly_sample <-  read_csv("./data/clean/bolly_sample_100.csv")
bolly_sample <- bolly_sample %>% select(imdb_id, original_title, year_of_release)

# bring in plots for the movie sample
bolly_desc <- read_csv("./data/raw/plot/bolly_descriptions_100.csv") %>% select(-wiki_link)
bolly_plots <- bolly_sample %>% left_join(bolly_desc, by = "imdb_id")

# str_length 
bolly_plots <- bolly_plots %>% 
  mutate(plot_length = str_length(plot))


##########################
## Step II: Prepare srt ##
##########################

# Get list of .srt file paths
bolly_srt <- list.files("./data/raw/subtitles/all_srts/", full.names = TRUE)

# Convert to data frame and rename the column
bolly_srt <- data.frame(srt_path = bolly_srt, stringsAsFactors = FALSE)

# Add an empty imdb_id column
bolly_srt$imdb_id <- NA

# extract `imdb_id`
bolly_srt <- bolly_srt %>% 
  mutate(imdb_id = str_extract(srt_path, "tt\\d+"))

# we have multiple srt files for some `imdb_id`, likely an error or they are episodes of a series. Dropping them
bolly_srt %>% group_by(imdb_id) %>% count(sort = T)
cat("The number of srt with duplicates is:\n", dim(bolly_srt)[1], "\n")

# dropping the duplicates
bolly_srt <- bolly_srt %>% group_by(imdb_id) %>% 
  mutate(n = n()) %>% filter(n == 1) %>% select(-n)
cat("The number of srt without duplicates is:\n", dim(srt_address)[1], "\n")


# define a function to load and clean srt files

clean_subtitles <- function(file_path) {
  # Read raw lines with fallback encoding
  subtitle_text <- readLines(file_path, encoding = "UTF-8", warn = FALSE)
  
  # Coerce each line to valid UTF-8, replacing invalid bytes with empty string
  subtitle_text <- iconv(subtitle_text, from = "UTF-8", to = "UTF-8", sub = "")
  
  # Remove line numbers
  cleaned_lines <- subtitle_text[!grepl("^\\d+$", subtitle_text)]
  
  # Remove timestamps
  cleaned_lines <- cleaned_lines[!grepl("\\d{2}:\\d{2}:\\d{2},\\d{3}", cleaned_lines)]
  
  # Remove empty lines
  cleaned_lines <- cleaned_lines[nzchar(cleaned_lines)]
  
  # Remove watermark lines
  cleaned_lines <- cleaned_lines[!grepl("YTS|Downloaded from", cleaned_lines, ignore.case = TRUE)]
  
  # Combine into one string
  dialogue <- paste(cleaned_lines, collapse = "\n")
  
  # Final safeguard: remove any remaining encoding issues
  dialogue <- iconv(dialogue, from = "UTF-8", to = "UTF-8", sub = "")
  
  return(dialogue)
}



bolly_srt <- bolly_srt %>% mutate(dialogues = clean_subtitles(srt_path),
                                  dialogues_length = str_length(dialogues))
#############################
## Step III: Prepare build ##
#############################

# merge `bolly_srt` with `bolly_plots` to create `boolly_themes` build. 
bolly_themes <- bolly_plots %>% left_join(bolly_srt, by = "imdb_id")

# we observe that some movies do not have srt, some do not have plot, and some do not have both.
#We keep all of them to be analsed differently.


dir.create("data/build", recursive = TRUE, showWarnings = FALSE)

write.csv(bolly_themes, "./data/build/bolly_themes.csv")

