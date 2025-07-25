get_poster_from_imdb <- function(imdb_id, tmdb_api_key) {
  # Load required libraries
  library(httr)
  library(jsonlite)
  library(magick)
  
  # Step 1: Find TMDB ID from IMDb ID
  url_find <- paste0("https://api.themoviedb.org/3/find/", imdb_id,
                     "?api_key=", tmdb_api_key, "&external_source=imdb_id")
  
  res_find <- GET(url_find)
  data_find <- fromJSON(content(res_find, "text", encoding = "UTF-8"))
  
  if (length(data_find$movie_results) == 0) stop("Movie not found")
  
  tmdb_id <- data_find$movie_results$id[1]
  
  # Step 2: Get all images for this TMDB movie ID
  url_images <- paste0("https://api.themoviedb.org/3/movie/", tmdb_id,
                       "/images?api_key=", tmdb_api_key)
  
  res_images <- GET(url_images)
  data_images <- fromJSON(content(res_images, "text", encoding = "UTF-8"))
  
  # Step 3: Extract poster paths
  poster_paths <- data_images$posters$file_path
  
  if (length(poster_paths) == 0) stop("No posters found for this movie")
  
  # Choose the first poster
  selected_poster <- poster_paths[1]
  poster_url <- paste0("https://image.tmdb.org/t/p/original", selected_poster)
  
  # Step 4: Download and show the poster
  poster <- image_read(poster_url)

  # Save locally
  filename <- paste0("data/raw/posters/", imdb_id, "_poster.jpg")
  image_write(poster, filename)
  Sys.sleep(5)
  
  return(filename)  # Return the saved file name
}




















