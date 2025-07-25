library(httr)
library(rvest)
library(dplyr)

get_director_name <- function(imdb_id) {
  headers <- c(
    'Accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Language' = 'en-US,en;q=0.9',
    'Connection' = 'keep-alive',
    'Referer' = paste0('https://www.boxofficemojo.com/title/', imdb_id, '/?ref_=bo_se_r_1'),
    'Sec-Fetch-Dest' = 'document',
    'Sec-Fetch-Mode' = 'navigate',
    'Sec-Fetch-Site' = 'same-origin',
    'Sec-Fetch-User' = '?1',
    'Upgrade-Insecure-Requests' = '1',
    'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
    'sec-ch-ua' = '"Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"',
    'sec-ch-ua-mobile' = '?0',
    'sec-ch-ua-platform' = '"Windows"'
  )
  
  url <- paste0("https://www.boxofficemojo.com/title/", imdb_id, "/credits/?ref_=bo_tt_tab")
  
  res <- VERB("GET", url = url, add_headers(.headers = headers))
  Sys.sleep(5)
  tryCatch({
    cnc_data <- res %>% read_html() %>% html_table()
    film_makers <- cnc_data[[1]] %>%
      as.data.frame() %>%
      mutate(Role = tolower(Role))
    
    director_name <- film_makers %>%
      filter(Role == "director") %>%
      pull(Filmmakers)
    
    if(length(director_name) == 0) return(NA_character_)
    return(director_name[1])
  }, error = function(e) {
    return(NA_character_)
  })
}




























