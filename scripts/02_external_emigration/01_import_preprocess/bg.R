
# Bulgaria -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://www.nsi.bg/en/content/3060/migration-population-districts-municipalities-and-sex (retrieved 2 November 2023)
file_path <- here("data", "02_external_emigration", "bg", "Pop_5.1_Migration_DR_EN.xls")

# Get the names of all sheets in the Excel file
sheet_names <- excel_sheets(file_path)

# Import all sheets and merge into one dataframe
bg_emigration <- map_df(sheet_names, function(year) {
  
  # Read data from the current sheet
  df <- read_excel(file_path, sheet = year)
  
  # Perform transformations
  df <- df %>%
    rename_with(~paste0("V", seq_along(.))) %>% # Reset column names to generic names
    select(V1, V5) %>%
    rename(regionname = V1,
           emigration = V5) %>% 
    mutate(emigration = as.numeric(emigration),
           year = as.numeric(year))  # Convert year from sheet name to numeric
  
  return(df)
})

bg_emigration <- bg_emigration %>% 
  drop_na(emigration) %>% 
  dplyr::filter(regionname != "Total") %>% 
  mutate(abs_emigration = abs(emigration))

# Remove rows with duplicate "regionname" values and keep only the one with the higher "abs_emigration",
bg_emigration <- bg_emigration %>%
  group_by(regionname, year) %>%
  top_n(1, abs_emigration) %>%
  ungroup() %>% 
  select(-abs_emigration)

# Add NUTS3
bg_emigration <- bg_emigration %>% 
  left_join(cee_nuts3, by = c("regionname" = "NAME_LATN")) %>% 
  drop_na(NUTS_ID) %>% 
  distinct(year, NUTS_ID, .keep_all = T) %>% 
  select(year, NUTS_ID, regionname, emigration)


## Population -------------------------------------------------------------

# Source: https://www.nsi.bg/en/content/2975/population-districts-municipalities-place-residence-and-sex (retrieved 2 November 2023)
file_path <- here("data", "02_external_emigration", "bg", "Pop_6.1.1_Pop_DR_EN.xls")

# Get the names of all sheets in the Excel file
sheet_names <- excel_sheets(file_path)

# Import all sheets and merge into one dataframe
bg_population <- map_df(sheet_names, function(year) {
  
  # Read data from the current sheet
  df <- read_excel(file_path, sheet = year)
  
  # Perform transformations
  df <- df %>%
    rename_with(~paste0("V", seq_along(.))) %>% # Reset column names to generic names
    select(V1, V2) %>% 
    rename(regionname = V1,
           population = V2) %>% 
    mutate(population = as.numeric(population),
           year = as.numeric(year))  # Convert year from sheet name to numeric
  
  return(df)
})

bg_population <- bg_population %>% 
  drop_na(population) %>% 
  dplyr::filter(regionname != "Total")

# Sofia (stolitsa) has different name in 2010 and 2011
bg_population$regionname[bg_population$regionname == "Sofia cap."] <- "Sofia (stolitsa)"

# Remove rows with duplicate "regionname" values and keep only the one with the higher "abs_population",
bg_population <- bg_population %>%
  group_by(regionname, year) %>%
  top_n(1, population) %>%
  ungroup()

# Add NUTS3
bg_population <- bg_population %>% 
  left_join(cee_nuts3, by = c("regionname" = "NAME_LATN")) %>% 
  drop_na(NUTS_ID) %>% 
  distinct(year, NUTS_ID, .keep_all = T) %>%
  select(year, NUTS_ID, regionname, population)


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

bg <- bg_emigration %>% 
  left_join(select(bg_population, -regionname), by = c("year", "NUTS_ID")) %>% 
  mutate(emigration_yearly_per_1000 = (emigration/population) * 1000)# %>% 
  # select(NUTS_ID, year, emigration_yearly_per_1000)


## Calculate emigration between elections --------------------------------

# Use sum of emigration in a region between elections
# E.g. 2001, 2002, 2003 and 2004 for election in 2005
# Use average of population in a region between elections
# Calculate emigration per 1000 with this

# Create an empty dataframe to store the results
sum_results <- data.frame()
avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(bg_election_years) - 1)) {
  start_year <- bg_election_years[i]
  end_year <- bg_election_years[i + 1]
  
  # Filter and summarize emigration
  sum_data <- bg %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(sum_emigration = sum(emigration, na.rm = T))
  
  # Filter and average emigration
  avg_data <- bg %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(average_population = mean(population, na.rm = T))
  
  # Add the start and end years for reference
  sum_data$start_year <- start_year
  avg_data$start_year <- start_year
  sum_data$end_year <- end_year - 1
  avg_data$end_year <- end_year - 1
  
  # Append to the results dataframe
  sum_results <- rbind(sum_results, sum_data)
  avg_results <- rbind(avg_results, avg_data)
}

sum_results <- sum_results %>% 
  rename(election_year = end_year) %>% 
  mutate(election_year = election_year + 1) %>% 
  select(NUTS_ID, sum_emigration, election_year)

avg_results <- avg_results %>% 
  rename(election_year = end_year) %>% 
  mutate(election_year = election_year + 1) %>% 
  select(NUTS_ID, average_population, election_year)

election_emigration <- sum_results %>% 
  left_join(avg_results, by = c("NUTS_ID", "election_year")) %>% 
  mutate(emigration_election_year_per_1000 = (sum_emigration/average_population) * 1000) %>% 
  select(NUTS_ID, election_year, emigration_election_year_per_1000)

bg <- bg %>% 
  left_join(election_emigration, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Export ------------------------------

save(bg, file = here("data", "02_external_emigration", "bg", "bg.Rda"))
