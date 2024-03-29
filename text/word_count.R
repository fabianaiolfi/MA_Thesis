
# Function to remove R code chunks from content
remove_r_chunks <- function(content) {
  in_chunk <- FALSE
  cleaned_content <- c()
  
  for (line in content) {
    if (grepl("^```\\{r.*\\}", line)) {
      in_chunk <- TRUE
    } else if (grepl("^```$", line) && in_chunk) {
      in_chunk <- FALSE
    } else if (!in_chunk) {
      cleaned_content <- c(cleaned_content, line)
    }
  }
  
  return(cleaned_content)
}


count_words_in_rmd <- function(folder_path) {
  # Load required library
  if (!require("stringr")) install.packages("stringr")
  library(stringr)
  
  # Get a list of all Rmd files in the folder
  rmd_files <- list.files(path = folder_path, pattern = "\\.Rmd$", full.names = T, recursive = T)
  
  # List of files to exclude
  exclude_files <- c("00_titelblatt.Rmd", "appendix.Rmd", "abstract.Rmd")
  
  # Exclude specific files
  rmd_files <- rmd_files[!basename(rmd_files) %in% exclude_files]
  
  
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
    
    # Apply the function to your content
    cleaned_text <- remove_r_chunks(content)
    
    # Combine into a single text string
    text_content <- paste(cleaned_text, collapse = " ")
    
    # Count words in the text content
    word_count <- str_count(text_content, "\\S+")
    total_word_count <- total_word_count + word_count
  }
  
  return(total_word_count)
}

folder_path <- "text/thesis"
total_words <- count_words_in_rmd(folder_path)
cat("Total words in all Rmd files:", total_words)

# 240202: 11'449
# 240201: 11'382
# 240131: 11'155
# 240130: 10'850
# 240129: 10'395
# 240128: 10'172
# 240124: 10'239
# 240124: 9914
# 240123: 9735
# 240122: 7091
# 240119: 5811
# 240118: 3764
# 240117: 3195
# 240116: 2509
# 240115: 1909
# 240114: 578
