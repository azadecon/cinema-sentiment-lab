# cinema-sentiment-lab
A sentiment analysis of Bollywood films to explore political and cultural themes like Hindu-Muslim relations, gender dynamics, and nationalism using AI.
---



# Directory structure
```{bash}
├── data/
│   ├── clean/                  # Cleaned and sampled datasets
│   │   ├── bolly_sample_100.csv
│   │   ├── bolly_dir_collec.csv
│   │   ├── bolly_descriptions_100.csv
│   │   └── bolly_posters_100.csv
│   ├── raw/
│   │   ├── metadata/                # Raw scraped metadata (director names, box office)
│   │   ├── movie_data/              # Original Kaggle dataset files
│   │   ├── plot/                    # Raw movie descriptions/plots
│   │   ├── posters/                 # Raw movie poster images
│   │   └── subtitles/               # Raw subtitle files (zips and extracted .srt)
├── scripts/
│   ├── 00_collection_scraper.R      # Scrapes box office data from Box Office Mojo
│   ├── 00_director_scraper.R        # Scrapes director names from Box Office Mojo
│   ├── 00_poster_scraper.R          # Downloads movie posters via TMDb API
│   ├── 00_subtitle_scraper.R        # Downloads English subtitles via SubDL API
│   ├── 00_wiki_plot_scraper.R       # Scrapes movie plots from Wikipedia
│   ├── 01_data_sampling_and_setup.R # Downloads Kaggle data, samples movies
│   ├── 02_fetch_movie_assets.R      # Orchestrates collection of subtitles, plots, posters
│   └── 03_fetch_movie_metadata.R    # downloads and saves movie directors name and collections
│   └── 03_analyse_movie_metadata.R  # Analyzes director gender and box office, generates plots
│   └── 04_build_movie_themes.R      # build thematic data (plot + subtitles) 
│   └── 04_thematic_analysis.R       # Analyzes theme and senstiment
├── output/                     # Generated plots
├── cinema-sentiment-lab.Rproj  # RStudio project file
├── README.md                   # This file
└── supplementary_ideas.md      # Document proposing additional attributes
```

# Dependency and outputs
<img width="1982" height="750" alt="build" src="https://github.com/azadecon/cinema-sentiment-lab/blob/main/build.svg" />

Sure! Here's a detailed README based entirely on the R script you provided:

---

# Bollywood Movies Sampling

## Section Overview

This section downloads a comprehensive Bollywood movies dataset from Kaggle, filters the data to include only movies released after 2010, merges metadata, ratings, and text data, and creates a random sample of 100 movies for further analysis. The sample is saved for downstream tasks, along with a log of the sampling event.

---

## Data Sources Used

* **The Indian Movie Database** dataset from Kaggle
  Dataset URL: [https://www.kaggle.com/datasets/pncnmnp/the-indian-movie-database](https://www.kaggle.com/datasets/pncnmnp/the-indian-movie-database)
  This dataset contains multiple CSV files including movie metadata, ratings, and text data for Bollywood movies, covering the years 2010-2019.

---

## Description of Main Script and Its Purpose

* The provided R script performs the following main functions:

  * Authenticates and downloads the dataset from Kaggle using the Kaggle CLI.
  * Reads multiple CSV files containing Bollywood movie data.
  * Merges and filters the dataset to include movies released after 2010 with valid IMDb IDs and Wikipedia links.
  * Randomly samples 100 movies from this filtered dataset.
  * Saves the sampled dataset as a CSV file.
  * Logs the sampling event with a timestamp, sample size, and seed used.

---

## Data Processing and Analysis Steps

1. **Setup and Authentication**

   * Ensures the Kaggle API key file (`kaggle.json`) is placed in the appropriate directory for authentication.
   * Installs and loads required R and Python packages (`tidyverse`, `reticulate`, and `kaggle` Python package).
   * Creates necessary directories to store raw and cleaned data.

2. **Dataset Download**

   * Downloads the dataset from Kaggle using the Kaggle CLI.
   * Unzips the files into `data/raw/movie_data`.

3. **Data Loading**

   * Reads four CSV files (`bollywood_2010-2019.csv`, `bollywood_meta_2010-2019.csv`, `bollywood_ratings_2010-2019.csv`, `bollywood_text_2010-2019.csv`) into R as data frames.

4. **Data Merging and Filtering**

   * Converts the `year_of_release` field to numeric.
   * Filters for movies that have a unique `imdb_id`.
   * Joins metadata and main movie data based on `imdb_id`.
   * Filters movies released after 2010 and having non-missing Wikipedia links.
   * Merges the above data with ratings and text information.
   * Ensures there are no duplicate `imdb_id` entries after merging.

5. **Random Sampling**

   * Sets the random seed (`1234`) for reproducibility.
   * Randomly samples 100 movies from the filtered dataset.
   * Cleans and renames columns for clarity.

6. **Output and Logging**

   * Saves the sampled data as `data/clean/bolly_sample_100.csv`.
   * Logs the sampling event with a timestamp, sample size, and seed in `data/clean/sampling.log`.

---

## Outputs Generated

* `data/raw/movie_data/`
  Directory containing raw dataset files downloaded and unzipped from Kaggle.

* `data/clean/bolly_sample_100.csv`
  CSV file containing the randomly sampled 100 Bollywood movies with merged metadata, ratings, and text.

* `data/clean/sampling.log`
  Log file appending details about each sampling event including date/time, sample size, and seed.

---

## How to Run the Code in the Right Order

1. **Prepare Kaggle API Key**

   * Download `kaggle.json` from your Kaggle account and place it in the parent directory (or update the path in the script accordingly).

2. **Run the R Script**

   * Execute the entire script in an R environment with internet access.
   * The script will handle package installation, dataset download, data processing, sampling, and saving outputs.

3. **Check Outputs**

   * After running, find the sampled movies CSV at `data/clean/bolly_sample_100.csv`.
   * Review the sampling log at `data/clean/sampling.log`.

---

## Important Notes About Dependencies and Usage

* **Dependencies:**

  * R packages: `tidyverse`, `reticulate`
  * Python package (installed via R): `kaggle` (for API interaction)
  * Kaggle CLI must be accessible via command line for dataset download (`system2("kaggle", ...)`).

* **Kaggle API Key:**

  * The script expects a valid Kaggle API key file (`kaggle.json`) placed either in the user's home `.kaggle` directory or copied there by the script from `../kaggle.json`.
  * Ensure the Kaggle CLI is installed and configured properly to allow downloading datasets.

* **Reproducibility:**

  * Random seed is set to `1234` to ensure the same sample can be reproduced.

* **File Paths:**

  * The script creates and uses the following directories:

    * Raw data: `data/raw/movie_data/`
    * Clean data and logs: `data/clean/`

---


# Movie Metadata Collection and Analysis

Pipeline & Workflow

## Step 1: Dataset & Sampling
- Downloaded the full Indian Movie Database from Kaggle: link
- Randomly sampled 100 movies released after 2010 using Python script (src/sample_movies.py)
- Saved sample with all attributes in data/movie_sample.csv

## Step 2: Collecting Movie Materials
For each sampled movie:
- Downloaded English subtitles (.srt) via OpenSubtitles API — saved in data/subtitles/
- Collected movie descriptions/synopsis from TMDb API — saved in data/descriptions/
- Downloaded movie posters using TMDb API — saved in data/posters/

## Step 3: Descriptive Metadata
- Extracted director gender using name-based gender inference (via gender_guesser Python package)
- Scraped box office data where available, documented sources in data/movie_sample.csv
- Metadata summary table and plots are in notebooks/metadata_analysis.ipynb

## Step 4: Thematic Coding
- Coded movies for themes (Hindu–Muslim relations, Gender relations, Nationalism) based on subtitles and synopsis
- Used OpenAI API for sentiment classification on three axes:
  - Exclusionary vs Secular (Inclusive)
  - Positive vs Negative
  - Progressive vs Conservative

- Proposed an additional sentiment measure: Emotional intensity (justification below)
- Saved coding results in data/theme_coding.json

## Step 5: Visualization
- Created time series plots using R’s ggplot2 (in plots/ and script src/plot_theme_trends.R)
- Visualizations show theme frequency and sentiment trends over 2010–present

## Step 6: Supplementary Ideas
- Proposed 3+ additional attributes to enrich dataset in supplementary_ideas.md

## Overview

In this section we collect and analyzes descriptive metadata for a sample of Bollywood movies, focusing on:

* **Director gender inference** based on scraped director names using a large language model (Google Gemini API).
* **Box office collection data** scraped automatically from Box Office Mojo.
* Summary tables and plots illustrating gender distribution and box office revenue patterns.

---

## Data Collection

### Sources

* **Movie IDs and basic metadata:** `./data/clean/bolly_sample_100.csv` (IMDB IDs)
* **Director names:** Scraped from IMDB pages using `scripts/00_director_scraper.R`
* **Box office revenue:** Scraped from Box Office Mojo using `scripts/00_collection_scraper.R`
* **Director gender inference:** Performed using the Google Gemini LLM API, predicting gender and probability from director names.

### Methods

* Director names and box office collections are scraped programmatically using R scripts.
* Gender is inferred via the `gender_finder` function, which sends a prompt to the Google Gemini API asking for the likely gender and probability given a Bollywood director's name.
* Data cleaning includes removal of currency symbols and conversion of box office values to numeric for analysis.

---

## Outputs

* Metadata CSV files saved in `./data/raw/metadata/` and `./data/clean/`
* Visualizations saved in `./output/`:

  * `gender_summary_movies.png`: Bar plot of director gender distribution.
  * `gender_summary_collection.png`: Boxplots of box office revenue by director gender.
  * `year_summary_collection.png`: Boxplots of box office revenue by year with mean and median overlays.

---

## Usage

1. Run the scraping scripts to help collect director names and box office collections:

   ```r
   source("./scripts/00_director_scraper.R")
   source("./scripts/00_collection_scraper.R")
   ```
2. Run the analysis script `03_analyse_movie_metadata.R` to infer gender, merge data, and generate plots.
3. View outputs in the `./output/` folder and review cleaned datasets in `./data/clean/`.

---

## Notes

* The gender inference is based on name-based probabilistic estimates via LLM and may not reflect exact demographics.
* Box office data scraping depends on availability from Box Office Mojo and may have gaps or missing values.
* Ensure you set your Google Gemini API key in environment variables as `GEMINI_API_KEY` before running gender inference.

---

## References

* [IMDB](https://www.imdb.com/)
* [Box Office Mojo](https://www.boxofficemojo.com/)
* Google Gemini API (used for gender inference)

---
