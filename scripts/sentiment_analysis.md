I ran out of LLM credits, so I have outlined my steps as follows.
I would however like to point out my technical skills as demonstrated in `API discovery`, `API handling`, and data pipeline to name a few.

# Goal:
> To analyze sentiment across the entire movie subtitle file in manageable segments.

## Strategy:
> Chunking the Subtitles: LLM tools have context window limit and their analysis gets lets precise with size. Since the full subtitle text is too large to analyze at once, it will be split into smaller, manageable chunks (e.g., by number of lines or timestamps).


## Using the Plot as a Sentiment Guide
> We use the movie plot as a reference to determine expected emotional themes (e.g., joy, fear, anger). This will anchor the LLM. 
For each chunk, assess whether the sentiment aligns with those found in the plot. This allows thematic alignment rather than generic sentiment scoring.

## Aggregation Method
> For each identified sentiment, compute its intensity across all chunks.
We take the maximum score for each sentiment across the chunks to highlight the most intense expression of that emotion in the movie.
This avoids dilution of strong emotions that occur only briefly.

## Improving the Plot Reference
> We can use multiple plot sources (e.g., Wikipedia, IMDb, possibly Letterboxd or Rotten Tomatoes) to ensure a richer understanding of the story and themes.
Letterboxd has lately emerged as more truthful repoting/discussion of movie plots.
We can merge key plot details to get a more nuanced sentiment guide.









