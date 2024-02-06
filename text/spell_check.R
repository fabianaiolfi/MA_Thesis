
# Spell check Rmd files
# library(spelling)

# Get all file names
main_folder_path <- here("text", "thesis")

# Create a vector of all Rmd file names
rmd_files <- list.files(path = main_folder_path, 
                        pattern = "\\.Rmd$", 
                        recursive = TRUE, 
                        full.names = TRUE)

# Remove 00_titelblatt.Rmd
rmd_files <- rmd_files[-1]

sc <- spelling::spell_check_files(rmd_files, lang = "en-GB", ignore = c("CEE", "CHES", "pagebreak", "RO", "PL", "Czechia", "Voivodeship", "uptick", "operationalisation"))
