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

# Objective

This project aims to build a reproducible data pipeline and perform a preliminary analysis of cultural and political themes in contemporary Bollywood cinema. Using a sample of 100 post-2010 Indian films, we collect subtitles, plot, and posters to explore themes such as Hindu–Muslim relations, gender dynamics, and nationalism. This pipeline supports the analysis such as metadata enrichment, thematic sentiment classification using LLMs, and visualizations of trends over time.

# Data Sources Used
We only document the tools/data sources used here. Methods of obtaining the access is beyond the scope of this project.
* **The Indian Movie Database** dataset from Kaggle
  Dataset URL: [https://www.kaggle.com/datasets/pncnmnp/the-indian-movie-database](https://www.kaggle.com/datasets/pncnmnp/the-indian-movie-database)
  This dataset contains multiple CSV files including movie metadata, ratings, and text data for Bollywood movies, covering the years 2010-2019.
* [IMDB](https://www.imdb.com/)
* [Box Office Mojo](https://www.boxofficemojo.com/)
* [Subdl](https://subdl.com/)
* [TMDB](https://www.themoviedb.org/)
* Google Gemini API (used for gender inference and thematic analysis)

# Dependency
This pipeline depends on follwing api/credentials. Please enusre their availability.
- `gemini_api_key`
- `tmdb_api_key`
- `subdl_api_key`
- `kaggle.json`

# scripts
- Scripts starting with `00` are helper scripts and they must be made available wherever they are required.
- Rest scripts follow this order: `01_data_sampling_and_setup.R ==> 02_fetch_movie_assets.R ==> 03_fetch_movie_metadata.R ==> 03_analyse_movie_metadata.R ==> 04_build_movie_themes.R ==> 04_thematic_analysis.R`

# Data
- `/data/raw` comprises of all the downloaded data, including but not limited to `.srt`.
- `/data/clean` has them cleaned, combined and uniquely identified with `imdb_id` and ready for further merging or analysis.
- `/data/build` has the data ready for thematic analysis.

# Output
It contains all the graphs.

---
For further details consult the respective scripts. 



---
