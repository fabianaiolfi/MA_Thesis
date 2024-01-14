
count_words_in_rmd <- function(folder_path) {
  # Load required library
  if (!require("stringr")) install.packages("stringr")
  library(stringr)
  
  # Get a list of all Rmd files in the folder
  rmd_files <- list.files(path = folder_path, pattern = "\\.Rmd$", full.names = TRUE)
  
  # Initialize word count
  total_word_count <- 0
  
  # Process each file
  for (file in rmd_files) {
    # Read the file content
    content <- readLines(file, warn = FALSE)
    
    # Filter out HTML comments and lines starting with a backslash
    content <- gsub("<!--.*?-->", "", content, perl = TRUE)  # Remove HTML comments
    content <- content[!grepl("^\\s*\\\\", content)]        # Exclude lines starting with backslash
    
    # Extracting only the text parts (ignoring R code)
    # This is a basic extraction and might need refinement based on file content
    text_content <- paste(content[!grepl("```", content)], collapse = " ")
    
    # Remove references like [@...]
    text_content <- gsub("\\[@[^]]+\\]", "", text_content)
    
    # Count words in the text content
    word_count <- str_count(text_content, "\\S+")
    total_word_count <- total_word_count + word_count
  }
  
  return(total_word_count)
}

folder_path <- "text/thesis"
total_words <- count_words_in_rmd(folder_path)
cat("Total words in all Rmd files:", total_words)

# 240114: 578
