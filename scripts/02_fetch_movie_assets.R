#########################################################################################################
#Purpose: to Collect movie materials(subtitles,  for the sample movies
#########################################################################################################

#########################################################################################################
#Section I: obtain movies subtitles file (.srt)
#########################################################################################################

library(tidyverse)
library(jsonlite)
library(httr)
library(tools)

## setting the globals (as in the .Renviron file)
sub_dl_api <- Sys.getenv("SUB_DL_API")

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

# define the scraping function
get_subtitle <- function(imdb_id,
                         api_key = sub_dl_api,
                         language = "EN") {
  # Use global dirs directly
  download_dir <- download_dir
  common_srt_dir <- common_srt_dir
  
  
  # Build request URL
  req_url <- paste0(
    "https://api.subdl.com/api/v1/subtitles?",
    "api_key=", api_key,
    "&imdb_id=", imdb_id,
    "&type=movie",
    "&languages=", language
  )
  
  # Perform request
  res <- tryCatch({
    VERB("GET", url = req_url)
  }, error = function(e) {
    message("Request error for ", imdb_id)
    return(NULL)
  })
  
  if (is.null(res) || status_code(res) != 200) {
    message("HTTP error for ", imdb_id)
    return(NULL)
  }
  
  # Parse JSON
  json_content <- content(res, "text", encoding = "UTF-8")
  data_recvd <- fromJSON(json_content)
  
  # log the result of request
  subtitle_log <<- rbind(
    subtitle_log,
    data.frame(imdb_id = imdb_id, status = isTRUE(data_recvd$status), stringsAsFactors = FALSE)
  )
  
  
  
  if (!isTRUE(data_recvd$status) || is.null(data_recvd$subtitles$url[1])) {
    message("No subtitles for ", imdb_id)
    return(NULL)
  }
  
  # Download ZIP
  zip_suburl <- data_recvd$subtitles$url[1]
  srt_zip_url <- paste0("https://dl.subdl.com", zip_suburl)
  destfile <- file.path(download_dir, paste0(imdb_id, ".zip"))
  
  tryCatch({
    download.file(srt_zip_url, destfile = destfile, mode = "wb")
    message("Downloaded for ", imdb_id)
    
    # Unzip to temp dir
    unzip_dir <- file.path(download_dir, imdb_id)
    dir.create(unzip_dir, showWarnings = FALSE)
    unzip(destfile, exdir = unzip_dir)
    
    # List .srt files
    srt_files <- list.files(unzip_dir, pattern = "\\.srt$", full.names = TRUE)
    if (length(srt_files) == 0) {
      message("No .srt files found for ", imdb_id)
      return(NULL)
    }
    
    # Move and rename .srt files
    moved_files <- c()
    for (i in seq_along(srt_files)) {
      ext <- file_ext(srt_files[i])
      new_name <- if (length(srt_files) == 1) {
        paste0(imdb_id, ".", ext)
      } else {
        paste0(imdb_id, "_", i, ".", ext)
      }
      new_path <- file.path(common_srt_dir, new_name)
      file.copy(srt_files[i], new_path, overwrite = TRUE)
      moved_files <- c(moved_files, new_path)
    }
    
    return(moved_files)
    
  }, error = function(e) {
    message("Download/unzip error for ", imdb_id)
    return(NULL)
  })
}

# initialise the list of `imdb_id`
bolly_sample_100 <- read_csv("./data/clean/bolly_sample_100.csv")
imdb_vec <- bolly_sample_100$imdb_id

# scrape all subtitles
results_list <- lapply(imdb_vec, get_subtitle)



#########################################################################################################
#Section II: obtain movies subtitles file (.srt)
#########################################################################################################






























