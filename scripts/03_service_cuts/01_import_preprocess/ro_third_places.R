
# Third Places --------------------------------

## Third Places at NUTS3 --------------------------------

### Third Places 2008--2021 ----------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (Retrieved 15 December 2023)
raw_data <- read_excel(here("data", "03_service_cuts", "ro", "TEMPO_INT101U_15_12_2023.xlsx")) # Manually converted .xls to .xlsx

ro_third_places <- raw_data %>% 
  select(-c(1, 2))

year_names <- as.character(2008:2021)
current_names <- colnames(ro_third_places) # Getting the current column names
current_names[2:15] <- year_names # Replacing the names of columns 2 through 29
colnames(ro_third_places) <- current_names # Assigning the new names back to the dataframe

ro_nuts2 <- c("CENTER", "MACROREGION 2", "NORTH - EAST", "SOUTH - EAST", "MACROREGION 3", "SOUTH - MUNTENIA", "BUCHAREST - ILFOV", "MACROREGION 4", "SOUTH - WEST OLTENIA", "WEST")
ned_v_dem_ro <- ned_v_dem_cee %>% select(country, regionname, nuts2016) %>% dplyr::filter(country == "Romania") %>% distinct(regionname, .keep_all = T) %>% select(-country)

ro_third_places_08_21 <- ro_third_places %>% 
  slice(8:n()) %>% 
  rename(region = `...3`) %>% 
  drop_na(region) %>% 
  dplyr::filter(!region %in% ro_nuts2) %>% 
  mutate(region = case_when(region == "Bucharest Municipality" ~ "Bucuresti",
                            T ~ region))%>% 
  left_join(ned_v_dem_ro, by = c("region" = "regionname")) %>%
  select(-region) %>% 
  pivot_longer(cols = -nuts2016,
               names_to = "year",
               values_to = "third_places") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(third_places = as.numeric(third_places))


### Third Places 2002--2007 ----------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (Retrieved 8 January 2024)
raw_data <- read_excel(here("data", "03_service_cuts", "ro", "TEMPO_INT101J_8_1_2024.xlsx")) # Manually converted .xls to .xlsx

ro_third_places <- raw_data %>% 
  select(-c(1, 2, 10))

year_names <- as.character(2002:2007)
current_names <- colnames(ro_third_places) # Getting the current column names
current_names[2:7] <- year_names # Replacing the names of columns 2 through 29
colnames(ro_third_places) <- current_names # Assigning the new names back to the dataframe

ro_third_places_02_08 <- ro_third_places %>% 
  slice(8:n()) %>% 
  rename(region = `...3`) %>% 
  drop_na(region) %>% 
  dplyr::filter(!region %in% ro_nuts2) %>% 
  # mutate(region = case_when(region == "Bucharest Municipality" ~ "Bucuresti",
                            # T ~ region))%>% 
  left_join(ned_v_dem_ro, by = c("region" = "regionname")) %>%
  select(-region) %>% 
  pivot_longer(cols = -nuts2016,
               names_to = "year",
               values_to = "third_places") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(third_places = as.numeric(third_places))


## Third Places Merge ------------------------------

ro_third_places <- bind_rows(ro_third_places_02_08, ro_third_places_08_21)

ro_third_places <- ro_third_places %>% 
  left_join(ro_population, by = c("nuts2016" = "NUTS_ID", "year")) %>% 
  distinct(nuts2016, year, .keep_all = T) %>% 
  mutate(ratio_third_places = population / third_places) %>% 
  rename(NUTS_ID = nuts2016)


## Calculate ratio between elections --------------------------------

# Calculate average ratio between elections
# E.g. average of 2001, 2002, 2003 and 2004 for election in 2005

ro_third_places <- ro_third_places %>% 
  mutate(ratio_third_places_diff = c(NA, diff(ratio_third_places)))

avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(ro_election_years) - 1)) {
  start_year <- ro_election_years[i]
  end_year <- ro_election_years[i + 1]
  
  # Filter and average classrooms
  avg_data <- ro_third_places %>%
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

ro_third_places <- ro_third_places %>% 
  left_join(avg_results, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Calculate number of third places change between elections --------------------------------

# Calculate average change between elections
# E.g. average of 2001, 2002, 2003 and 2004 for election in 2005

ro_third_places <- ro_third_places %>% 
  mutate(third_places_diff = c(NA, diff(third_places)))

avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(ro_election_years) - 1)) {
  start_year <- ro_election_years[i]
  end_year <- ro_election_years[i + 1]
  
  # Filter and average classrooms
  avg_data <- ro_third_places %>%
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

ro_third_places <- ro_third_places %>% 
  left_join(avg_results, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Export ------------------------------

save(ro_third_places, file = here("data", "03_service_cuts", "ro", "ro_third_places.Rda"))
