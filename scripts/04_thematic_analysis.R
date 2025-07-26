##############################################################################
## Purpose: thematic analysis of the movies using movie plots and subtitles ##
##############################################################################

###########################
## Step I: Prepare plots ##
###########################

library(tidyverse)
library(ellmer)
library(jsonlite)
library(stringr)

gemini_api_key <- Sys.getenv("GEMINI_API_KEY")


#########################################################################################################
#Section I: thematic coding
#########################################################################################################

# load theme data

## some movies dont have plot or subtitles or both. Keeping only those with both
bolly_themes <- read_csv("./data/build/bolly_themes.csv") %>% select(-...1)
bolly_themes <- bolly_themes %>% filter(!is.na(plot)) %>% filter(!is.na(dialogues))

bolly_themes <- bolly_themes[42, ]


############################
#Section Ia: theme presence#
############################

## a function to use LLM to find theme


library(ellmer)
library(glue)
library(purrr)
library(dplyr)

theme_finder <- function(plot, theme) {
  chat <- chat_google_gemini(
    system_prompt = "You are an expert on themes and motifs in Indian Bollywood movies."
  )
  prompt <- glue(
    "Given the following plot of an Indian Bollywood movie, check if there is a theme of {theme}. ",
    "Use your best judgment and answer ONLY with 'Yes' or 'No' (no other commentary).\n",
    "Plot:\n{plot}"
  )
  Sys.sleep(1)
  resp <- tryCatch({
    out <- chat$chat(prompt)
    out <- tolower(trimws(out))
    yesno <- if (grepl("^yes\\b", out, ignore.case = TRUE)) "Yes"
    else if (grepl("^no\\b", out, ignore.case = TRUE)) "No"
    else NA_character_
    yesno
  }, error = function(e) NA_character_)
  resp
}

# Usage: pass a theme as string
bolly_themes <- bolly_themes %>%
  mutate(
    hindu_muslim        = map_chr(plot, ~theme_finder(.x, "Hindu–Muslim relations"), .progress = TRUE),
    love_story          = map_chr(plot, ~theme_finder(.x, "Gender relations"), .progress = TRUE),
    rural_vs_urban      = map_chr(plot, ~theme_finder(.x, "Nationalism"), .progress = TRUE)
  )

## for an extensive search, movie subtitle too can be used to find the presence of a theme.


########################################
#Section Ib: sentiment classification ##
########################################

## Since, I ran out of credits. Following I describe my strategy for sentiment analysis.
# See sentiment_analysis_strategy.md for details on the chunking and aggregation approach





