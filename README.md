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


# Movie Metadata Collection and Analysis

## Overview

This project collects and analyzes descriptive metadata for a sample of Bollywood movies, focusing on:

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

* Cleaned metadata CSV files saved in `./data/raw/metadata/` and `./data/clean/`
* Summary tables showing director gender counts and box office revenue statistics.
* Visualizations saved in `./output/`:

  * `gender_summary_movies.png`: Bar plot of director gender distribution.
  * `gender_summary_collection.png`: Boxplots of box office revenue by director gender.
  * `year_summary_collection.png`: Boxplots of box office revenue by year with mean and median overlays.

---

## Usage

1. Run the scraping scripts to collect director names and box office collections:

   ```r
   source("./scripts/00_director_scraper.R")
   source("./scripts/00_collection_scraper.R")
   ```
2. Run the analysis script to infer gender, merge data, and generate plots.
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
