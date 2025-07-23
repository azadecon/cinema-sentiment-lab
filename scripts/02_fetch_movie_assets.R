#########################################################################################################
#Purpose: to Collect movie materials(subtitles,  for the sample movies
#########################################################################################################

#########################################################################################################
#Section I: obtain movies subtitles file (.srt)
#########################################################################################################


library(tidyverse)
library(jsonlite)
library(httr)

headers = c(
  'accept' = 'application/json, text/plain, */*',
  'accept-language' = 'en-US,en;q=0.9',
  'origin' = 'https://subdl.com',
  'priority' = 'u=1, i',
  'referer' = 'https://subdl.com/',
  'sec-ch-ua' = '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
  'sec-ch-ua-mobile' = '?0',
  'sec-ch-ua-platform' = '"Windows"',
  'sec-fetch-dest' = 'empty',
  'sec-fetch-mode' = 'cors',
  'sec-fetch-site' = 'same-site',
  'user-agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36'
)

# create `query string` from `original_title` and `year_of_release`
query_text <- paste0("Aisa Yeh Jahaan", " 2015")
url_string <- paste0("https://api3.subdl.com/auto?query=", URLencode(query_text))
res <- VERB("GET", url = url_string, add_headers(headers))


cat(content(res, 'text'))

json_content <- content(res, "text")

data <- jsonlite::fromJSON(json_content)
data <- data$results
data <- data %>% as.data.frame()
data
