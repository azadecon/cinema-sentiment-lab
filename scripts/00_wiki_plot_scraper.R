library(httr)
library(jsonlite)
library(rvest)
library(dplyr)
library(purrr)

# function to clean text of footnotes and other junks
aclean_plot_text <- function(text) {
  text %>%
    # Remove '[edit]' headers
    gsub("\\[edit\\]", "", .) %>%
    # Remove numeric references like [1], [2], etc.
    gsub("\\[\\d+\\]", "", .) %>%
    # Remove footnote CSS garbage (everything after ^ or a citation)
    gsub("\\^.*", "", .) %>%
    # Remove leftover extra newlines
    gsub("\\n{2,}", "\n\n", .) %>%
    trimws()
}

clean_plot_text <- function(text) {
  text %>%
    gsub(".*?\\.mw-parser-output.*?\\n(?=[A-Z])", "", ., perl = TRUE) %>%
    gsub("\\[edit\\]", "", .) %>%
    gsub("\\[\\d+\\]", "", .) %>%
    gsub("\\^.*", "", .) %>%
    gsub("\\n{2,}", "\n\n", .) %>%
    trimws()
}


# Function to find the index of the 'Plot' section
get_plot_section_index <- function(page_title) {
  res <- GET("https://en.wikipedia.org/w/api.php", query = list(
    action = "parse",
    page = page_title,
    prop = "sections",
    redirects = 1,
    format = "json"
  ))
  
  if (http_error(res)) return(NA)
  
  sections <- content(res, as = "parsed")$parse$sections
  plot_section <- sections %>%
    keep(~ grepl("\\bplot\\b", .$line, ignore.case = TRUE))
  
  if (length(plot_section) > 0) {
    return(plot_section[[1]]$index)
  } else {
    return(NA)
  }
}

# Function to extract 'Plot' section text
get_plot_text <- function(wiki_url) {
  page_title <- sub("^.*/wiki/", "", wiki_url)
  
  section_index <- get_plot_section_index(page_title)
  if (is.na(section_index)) return(NA)
  
  res <- GET("https://en.wikipedia.org/w/api.php", query = list(
    action = "parse",
    page = page_title,
    section = section_index,
    redirects = 1,
    format = "json"
  ))
  
  if (http_error(res)) return(NA)
  
  tryCatch({
    html_raw <- content(res, as = "parsed")$parse$text$`*`
    plot_text <- read_html(html_raw) %>% html_text2()
    plot_text <- clean_plot_text(plot_text)
    return(plot_text)
  }, error = function(e) return(NA))
}


