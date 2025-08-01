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
│   ├── build/
│   │   ├── bolly_themes.csv         # build for thematic analysis
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

# Script Flow
<img width="1982" height="750" alt="build" src="https://github.com/azadecon/cinema-sentiment-lab/blob/main/build.svg" />

---

# Objective

This project aims to build a reproducible data pipeline and perform a preliminary analysis of cultural and political themes in contemporary Bollywood cinema. Using a sample of 100 post-2010 Indian films, we collect subtitles, plot, and posters to explore themes such as Hindu–Muslim relations, gender dynamics, and nationalism. This pipeline supports the analysis such as metadata enrichment, thematic sentiment classification using LLMs, and visualizations of trends over time.

# Data Sources Used
We only document the tools/data sources used here. Methods of obtaining the access is beyond the scope of this project.
* **The Indian Movie Database** dataset from Kaggle
  Dataset URL: [https://www.kaggle.com/datasets/pncnmnp/the-indian-movie-database](https://www.kaggle.com/datasets/pncnmnp/the-indian-movie-database)
  This dataset contains multiple CSV files with a variety of movie attributes but focus only on `imdb_id`, `movie_name` `year_of_release` and `wiki_link` only. We obtain rest of the data ourselves from following sources.
* [IMDB](https://www.imdb.com/): Used for unique movie identification (imdb_id)
* [Box Office Mojo](https://www.boxofficemojo.com/): Box office revenue and director data
* [Subdl](https://subdl.com/): Subtitle ZIP file acquisition
* [TMDB](https://www.themoviedb.org/): Poster images via tmdb_id lookup
* Google Gemini API (used for gender inference and thematic analysis): Used for gender inference and theme/sentiment classification

# Dependency
This pipeline depends on follwing api/credentials. Please ensure their availability.
- `gemini_api_key`
- `tmdb_api_key`
- `subdl_api_key`
- `kaggle.json`

# scripts
- Scripts starting with `00` are helper scripts and they must be made available wherever they are required.
- Rest scripts follow this order: `01_data_sampling_and_setup.R ==> 02_fetch_movie_assets.R ==> 03_fetch_movie_metadata.R ==> 03_analyse_movie_metadata.R ==> 04_build_movie_themes.R ==> 04_thematic_analysis.R`

# Data
- `/data/raw` All directly scraped or downloaded assets, including subtitles (.srt), plots, posters, and metadata.
- `/data/clean` Structured datasets uniquely indexed by `imdb_id`, suitable for merging and analysis.
- `/data/build` Aggregated inputs for thematic and sentiment analysis.


# Output
All final plots are stored in the /output directory and referenced in the main report.

---
# additional thematic measure

A thematic strand I would like to explore is that of **urban struggles**. While cities are often portrayed as centers of opportunity and aspiration, they also serve as spaces of profound challenges and contradictions. These struggles are uniquely tied to the urban context—shaped by its density, pace, anonymity, and inequality. For instance, `Gully Boy` portrays life in the slums and the aspirations that emerge from them; `Life in a... Metro` explores urban loneliness and emotional disconnection; `Wake Up Sid` and `Rocket Singh: Salesman of the Year` delve into questions of identity and self-discovery in a metropolitan environment. Similarly, `Lipstick Under My Burkha` and `Modern Love: Mumbai` depict the hidden, often suppressed, lives and relationships of women navigating the urban landscape.

While the subjects these films tackle—love, identity, ambition, alienation—are not unique to cities, their placement within an urban setting gives them new resonance and complexity. The challenges of city life demand solutions that are as particular and place-based as the problems themselves. A study focused through an urban lens can thus illuminate the ways in which cities shape, intensify, or even enable personal and social struggles—and perhaps suggest responses that address the alienating and dehumanizing aspects of modern urban existence.

# Looking Ahead
See `supplementary_ideas.md` for potential extensions, such as:
- trailer-based visual sentiment analysis
- User Reviews and Sentiment
- Social Media Mentions and
- Awards and Nominations

# Note on thematic analysis
Due to running out of LLM credits, I was unable to complete full-scale automated sentiment analysis. However, I have outlined my startegy for the same in the [`/scripts/sentiment_analysis.md`](https://github.com/azadecon/cinema-sentiment-lab/blob/main/scripts/sentiment_analysis.md) document.

---
