# Supplementary Ideas to Enrich the Dataset
*Overall Thought*: The key isn’t just what data to collect, but how to collect it. The process of gathering contextual, nuanced data often demands ingenuity.

For instance, `OpenSubtitles` provides a free API, but it's limited to just 10 subtitles per day. To get around this, I explored alternatives like `subdl` and other sources. I'm also comfortable working with undocumented APIs — which, frankly, can change everything in terms of access and scale.

## 1. Trailers and Their Transcriptions
- **Source**: YouTube. 
- **Approach**: Scrape or download trailer videos and extract subtitles via tools like `yt-dlp`.
- **additional thoughts**: trailers use texts in between scenes to present the core theme of the movies, by grabbing these texts from the stills much can be learnt.

## 2. User Reviews and Sentiment
- **Source**: IMDb, Letterboxd, Rotten Tomatoes
- **Approach**: Scrape or use APIs (if available) to collect review texts. Use OpenAI or Hugging Face models to analyze sentiment and extract themes.

## 3. Social Media Mentions
- **Source**: X (formerly Twitter), Reddit, Facebook
- **Approach**: Use X/Twitter API or Pushshift for Reddit to collect relevant posts. Filter by movie title and year.

## 4. Awards and Nominations
- **Source**: IMDb, national/filmfare awards, Wikipedia
- **Approach**: Scrape awards info per movie or use IMDb datasets for nominations/wins.

## 5. Caste Diversity (Gender, Religion, Nationality)
- **Source**: IMDb profiles, Wikipedia
- **Approach**: Scrape cast bios and apply NER (Named Entity Recognition) or classification models to infer demographics.



