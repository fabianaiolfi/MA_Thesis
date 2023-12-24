
# Get all file names

main_folder_path <- here("text", "data_analysis")

# Create a vector of all Rmd file names
rmd_files <- list.files(path = main_folder_path, 
                        pattern = "\\.Rmd$", 
                        recursive = TRUE, 
                        full.names = TRUE)

# Remove 06_sources.Rmd
rmd_files <- rmd_files[-14]

spelling::spell_check_files(rmd_files, lang = "en-GB", ignore = c("CEE", "CHES", "pagebreak", "RO", "PL", "Czechia", "Voivodeship", "uptick"))
