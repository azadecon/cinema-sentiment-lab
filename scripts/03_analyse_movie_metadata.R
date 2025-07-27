#########################################################################################################
#Purpose: to analyse movie metadata (director, boxoffice collection) for the sample movies
#########################################################################################################

# Install and load package
library(ellmer)
library(tidyverse)

gemini_api_key <- Sys.getenv("GEMINI_API_KEY")



#########################################################################################################
#Section I: load and merge director name and box office collection data
#########################################################################################################

## load directors data
bolly_direc <- read_csv("./data/raw/metadata/bolly_direc.csv")

## load collection data
bolly_collection <- read_csv("./data/raw/metadata/bolly_collection.csv")


## Merging them on `imdb_id`
bolly_dir_collec <- bolly_direc %>% left_join(bolly_collection, by = "imdb_id")


################################################
#Section II: predict gender for director name ##
################################################

## clean director name and collection

bolly_dir_collec <- bolly_dir_collec %>% 
  mutate(director = tolower(director)) %>% 
  mutate(collection_dollar = as.numeric(gsub("[\\$,]", "", collection))) %>% select(-collection)

## find gender

## a function to use LLM to find gender
gender_finder <- function(name) {
  chat <- chat_google_gemini() # new object, no history
  prompt <- paste(
    "Given the Indian Bollywood director's name, infer their most likely gender and associated probability.",
    "Use your best judgment and provide only the result in the form: gender - probability.",
    "Name:", name
  )
  Sys.sleep(1)
  response <- chat$chat(prompt)
  trimws(response)
}

## assign a gender and probability

bolly_dir_collec <- bolly_dir_collec %>%
  mutate(
    gender_prob = map_chr(director, gender_finder)
  )

# Split into gender and score, then pivot wider
bolly_dir_collec <- bolly_dir_collec %>%
  separate(gender_prob, into = c("gender", "probability"), sep = " - ")

# save the director gender and collection data for movies dataset.
dir.create("data/clean", recursive = TRUE, showWarnings = FALSE)
write_csv(bolly_dir_collec, "./data/clean/bolly_dir_collec.csv")




################################################
#Section III: analysis-
################################################

bolly_dir_collec <- read_csv("./data/clean/bolly_dir_collec.csv")

# Summarize count of director gender

gender_summary <- bolly_dir_collec %>%
  mutate(gender = tolower(gender)) %>% 
  group_by(gender) %>%
  summarise(count = n())

p1 <- ggplot(gender_summary, aes(x = gender, y = count, fill = gender)) +
  geom_col() +
  geom_text(aes(label = count), vjust = -0.5, size = 5) +  # ← Adds count labels
  theme_minimal() +
  labs(
    title = "Director Gender Distribution",
    x = "Gender",
    y = "Number of Directors"
  ) +
  theme(legend.position = "none")


dir.create("./output/", recursive = TRUE, showWarnings = FALSE)
ggsave("./output/gender_summary_movies.png", p1)

# Summarise box office collection

# Drop rows where box_office_clean is NA
movies_cleaned <- bolly_dir_collec %>%
  mutate(gender = tolower(gender)) %>% 
  filter(!is.na(collection_dollar)) %>% 
  mutate(collection_dollar_m = collection_dollar/1000000)

# Summary
revenue_summary <- movies_cleaned %>%
  group_by(gender) %>%
  summarise(
    mean_revenue = mean(collection_dollar_m),
    median_revenue = median(collection_dollar_m),
    .groups = 'drop'
  )

print(revenue_summary)

# Plot
p2 <- ggplot(movies_cleaned, aes(x = gender, y = collection_dollar_m, fill = gender)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Box Office Revenue by Director Gender", y = "Revenue")



dir.create("./output/", recursive = TRUE, showWarnings = FALSE)
ggsave("./output/gender_summary_collection.png", p2)


#######################
# year-wise analysis ##
#######################

# Clean box office and drop NAs
bolly_sample <- read_csv("./data/clean/bolly_sample_100.csv")
bolly_sample <- bolly_sample %>% select(original_title, imdb_id, year_of_release)

bolly_dir_collec <- read_csv("./data/clean/bolly_dir_collec.csv")
bolly_revised <- bolly_dir_collec %>% left_join(bolly_sample, by = "imdb_id")

# save the revised movies dataset.
dir.create("data/clean", recursive = TRUE, showWarnings = FALSE)
write_csv(bolly_revised, "./data/clean/bolly_revised.csv")



movies_cleaned <- bolly_dir_collec %>%
  filter(!is.na(collection_dollar))

# Summary by year only

# Assuming movies_cleaned already exists with box_office_clean and year_of_release

# Summary by year (mean and median)
revenue_summary_by_year <- movies_cleaned %>%
  group_by(year_of_release) %>%
  summarise(
    mean_revenue = mean(collection_dollar, na.rm = TRUE),
    median_revenue = median(collection_dollar, na.rm = TRUE),
    .groups = 'drop'
  )

# Plot boxplots + mean & median lines
p3 <- ggplot(movies_cleaned, aes(x = factor(year_of_release), y = collection_dollar)) +
  geom_boxplot(fill = "skyblue", alpha = 0.6) +
  geom_point(data = revenue_summary_by_year, aes(x = factor(year_of_release), y = mean_revenue),
             color = "red", size = 2, shape = 18) +
  geom_point(data = revenue_summary_by_year, aes(x = factor(year_of_release), y = median_revenue),
             color = "blue", size = 2, shape = 17) +
  theme_minimal() +
  labs(
    title = "Box Office Revenue by Year with Mean (red) and Median (blue)",
    x = "Year",
    y = "Revenue"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.margin = margin(t = 20, r = 10, b = 10, l = 10),
    plot.title = element_text(margin = margin(b = 15), size = 16)
  )

dir.create("./output/", recursive = TRUE, showWarnings = FALSE)
ggsave("./output/year_summary_collection.png", p3, width = 10, height = 6)





