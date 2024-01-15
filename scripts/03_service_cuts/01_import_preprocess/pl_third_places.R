
# Third Places --------------------------------

## Third Places at NUTS2 --------------------------------

# Restaurants
# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 27 November 2023)
raw_csv <- read_delim(here("data", "03_service_cuts", "pl", "HAND_2505_CTAB_20231127091326.csv"),
                      delim = ";")

pl_restaurants <- raw_csv %>% 
  select(-c(Code, `...21`)) %>% 
  rename(regionname = Name)

# Rename columns to year
year_names <- as.character(2005:2022)
current_names <- colnames(pl_restaurants) # Getting the current column names
current_names[2:19] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_restaurants) <- current_names # Assigning the new names back to the dataframe

# More preprocessing
pl_restaurants <- pl_restaurants %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>%
  left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Mazowieckie" ~ "PL92",
                             #regionname == "City With Powiat Status Capital City Warszawa" ~ "PL91",
                             T ~ NUTS_ID)) %>%
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "restaurants") %>% 
  mutate(year = as.numeric(year))

# Bars
# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 27 November 2023)
raw_csv <- read_delim(here("data", "03_service_cuts", "pl", "HAND_2505_CTAB_20231127091429.csv"),
                      delim = ";")

pl_bars <- raw_csv %>% 
  select(-c(Code, `...21`)) %>% 
  rename(regionname = Name)

# Rename columns to year
year_names <- as.character(2005:2022)
current_names <- colnames(pl_bars) # Getting the current column names
current_names[2:19] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_bars) <- current_names # Assigning the new names back to the dataframe

# More preprocessing
pl_bars <- pl_bars %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>%
  left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Mazowieckie" ~ "PL92",
                             #regionname == "City With Powiat Status Capital City Warszawa" ~ "PL91",
                             T ~ NUTS_ID)) %>%
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "bars") %>% 
  mutate(year = as.numeric(year))


## Third Places Merge ------------------------------

pl_third_places <- pl_restaurants %>%
  left_join(pl_bars, by = c("NUTS_ID", "year")) %>% 
  # mutate(third_places = restaurants + bars) %>% 
  mutate(third_places = bars)



## Population ----------------------------

load(here("data", "02_external_emigration", "pl", "pl_population.Rda"))
  

## Ratio of Third Places ----------------------------

pl_third_places <- pl_third_places %>% 
  left_join(pl_population, by = c("NUTS_ID", "year")) %>% 
  mutate(ratio_third_places = population / third_places) %>% 
  mutate(ratio_bars = population / bars)


## Calculate ratio between elections --------------------------------

# Calculate average ratio between elections
# E.g. average of 2001, 2002, 2003 and 2004 for election in 2005

pl_third_places <- pl_third_places %>% 
  mutate(ratio_third_places_diff = c(NA, diff(ratio_third_places)))

avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(pl_election_years) - 1)) {
  start_year <- pl_election_years[i]
  end_year <- pl_election_years[i + 1]
  
  # Filter and average classrooms
  avg_data <- pl_third_places %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(average_ratio_third_places_election_year = mean(ratio_third_places_diff, na.rm = T))
  
  avg_data$start_year <- start_year
  avg_data$end_year <- end_year - 1
  
  # Append to the results dataframe
  avg_results <- rbind(avg_results, avg_data)
}

avg_results <- avg_results %>% 
  rename(election_year = end_year) %>% 
  mutate(election_year = election_year + 1) %>% 
  select(NUTS_ID, average_ratio_third_places_election_year, election_year)

pl_third_places <- pl_third_places %>% 
  left_join(avg_results, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Calculate number of third places change between elections --------------------------------

# Calculate average change between elections
# E.g. average of 2001, 2002, 2003 and 2004 for election in 2005

pl_third_places <- pl_third_places %>% 
  mutate(third_places_diff = c(NA, diff(third_places)))

avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(pl_election_years) - 1)) {
  start_year <- pl_election_years[i]
  end_year <- pl_election_years[i + 1]
  
  # Filter and average classrooms
  avg_data <- pl_third_places %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(average_third_places_diff_election_year = mean(third_places_diff, na.rm = T))
  
  avg_data$start_year <- start_year
  avg_data$end_year <- end_year - 1
  
  # Append to the results dataframe
  avg_results <- rbind(avg_results, avg_data)
}

avg_results <- avg_results %>% 
  rename(election_year = end_year) %>% 
  mutate(election_year = election_year + 1) %>% 
  select(NUTS_ID, average_third_places_diff_election_year, election_year)

pl_third_places <- pl_third_places %>% 
  left_join(avg_results, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Export ------------------------------

save(pl_third_places, file = here("data", "03_service_cuts", "pl", "pl_third_places.Rda"))
