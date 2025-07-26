#########################################################################################################
#Purpose: to Collect movie materials (subtitles, descriptions/plot, posters)  for the sample movies
#########################################################################################################

## setting the globals (as in the .Renviron file)
sub_dl_api <- Sys.getenv("SUB_DL_API")
tmdb_api_key <- Sys.getenv("TMDB_API_KEY")

## source helper functions
### subtitle scraper
source("./scripts/00_subtitle_scraper.R")

### Wikipedia scraper for plots
source("./scripts/00_wiki_plot_scraper.R")

### poster scraper [from tmdb]
source("./scripts/00_poster_scraper.R")


#########################################################################################################
#Section I: obtain movies subtitles file (.srt)
#########################################################################################################

library(tidyverse)
library(jsonlite)
library(httr)
library(tools)

# initialize an empty dataframe to record the request status
subtitle_log <- data.frame(
  imdb_id = character(),
  status = logical(),
  stringsAsFactors = FALSE
)

# Define and create directories once, globally
download_dir = "./data/raw/subtitles/zips"
if (!dir.exists(download_dir)) dir.create(download_dir, recursive = TRUE)

common_srt_dir = "./data/raw/subtitles/all_srts/"
if (!dir.exists(common_srt_dir)) dir.create(common_srt_dir, recursive = TRUE)

# initialize the list of `imdb_id`
bolly_sample_100 <- read_csv("./data/clean/bolly_sample_100.csv")
imdb_vec <- bolly_sample_100$imdb_id

# scrape all subtitles
lapply(imdb_vec, get_subtitle)


# calculate the success rate
num_srt <- length(list.files(common_srt_dir))
pct_plot <- 100*num_srt/nrow(bolly_descriptions_100)
cat("The success rate is:\n", pct_plot, "%\n")

# Its likely that the rest of the movies are slightly obscure.
# though this is on low side, rest of the subtitles can be downloaded from other sources.
# we can try other subtitle websites (it is a matter of API discovery)
# other prominent source can be torrent websites (unethical but a good source nevertheless)


#########################################################################################################
#Section II: obtain movies description (plot) from Wikipedia
#########################################################################################################

# initialise the list of `wiki_link`
bolly_descriptions_100 <- read_csv("./data/clean/bolly_sample_100.csv") %>% select(imdb_id, wiki_link)

# Apply the wikipedia scraper to each row and create a new column to bring all descriptions
bolly_descriptions_100$plot <- map_chr(bolly_descriptions_100$wiki_link, get_plot_text)

# calculate the success rate
pct_plot <- 100*sum(!is.na(bolly_descriptions_100$plot))/nrow(bolly_descriptions_100)
cat("The success rate is:\n", pct_plot, "%\n")

# though this is on higher side, this can still be improved. Plot/synopsis/descriptions are relatively abundant.
# other sources could be `wikidata`, `imdb`, `google knowledge graph` etc.

## its likely that some wikipedia page didnt have plots. checking a few to confirm
movies_to_check <- bolly_descriptions_100 %>% filter(is.na(plot)) %>% select(-plot)

# Select one random NA plot row
random_link <- sample(movies_to_check$wiki_link, 1)

# Open it in the browser
browseURL(random_link)

## some movies have `Synopsis` instead of `plot`, this can be searched in addition to find the movie description.

# save the plot
dir.create("data/raw/plot", recursive = TRUE, showWarnings = FALSE)
write_csv(bolly_descriptions_100, "./data/raw/plot/bolly_descriptions_100.csv")



#########################################################################################################
#Section III: obtain movies posters from Wikipedia
#########################################################################################################
bolly_posters_100 <- read_csv("./data/clean/bolly_sample_100.csv") %>% select(imdb_id)

dir.create("data/raw/posters", recursive = TRUE, showWarnings = FALSE)

bolly_posters_100$posters <- map_chr(bolly_posters_100$imdb_id, ~ get_poster_from_imdb(.x, tmdb_api_key))


# calculate the success rate
pct_plot <- 100*sum(!is.na(bolly_posters_100$posters))/nrow(bolly_posters_100)
cat("The success rate is:\n", pct_plot, "%\n")


# though this is on higher side, this can still be improved.
# other sources could be `wikipedia`.

## its likely that some tmdb page didnt have posters.

# save the posters link: this allows to link posters to `imdb_id`


# Get list of poster paths
bolly_posters_paths <- list.files("./data/raw/posters/", full.names = TRUE)

# Convert to data frame and rename the column
bolly_posters_paths <- data.frame(poster_path = bolly_posters_paths, stringsAsFactors = FALSE)

# Add an empty imdb_id column
bolly_posters_paths$imdb_id <- NA

# extract `imdb_id`
bolly_posters_paths <- bolly_srt %>% 
  mutate(imdb_id = str_extract(bolly_posters_paths, "tt\\d+"))

dir.create("data/clean/", recursive = TRUE, showWarnings = FALSE)
write_csv(bolly_posters_paths, "./data/clean/bolly_posters_100.csv")




















