
## Hospital Beds -------------------------
# Source: https://ec.europa.eu/eurostat/databrowser/view/hlth_rs_bdsrg__custom_8678583/default/table?lang=en (retrieved 24 November 2023)
raw_csv <- read_csv(here("data", "03_service_cuts", "pl", "hlth_rs_bdsrg__custom_8678583_linear.csv"))

pl_hospital_beds <- raw_csv %>% 
  select(geo, TIME_PERIOD, OBS_VALUE) %>% 
  rename(NUTS_ID = geo,
         year = TIME_PERIOD,
         hospital_beds = OBS_VALUE) %>% 
  mutate(NUTS_ID = case_when(NUTS_ID == "PL11" ~ "PL71",
                             NUTS_ID == "PL12" ~ "PL92",
                             NUTS_ID == "PL12" ~ "PL92",
                             NUTS_ID == "PL31" ~ "PL81",
                             NUTS_ID == "PL32" ~ "PL82",
                             NUTS_ID == "PL33" ~ "PL72",
                             NUTS_ID == "PL34" ~ "PL84",
                             T ~ NUTS_ID))


# Hospitals ---------------------------------
# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 24 November 2023)
raw_csv <- read_delim(here("data", "03_service_cuts", "pl", "OCHR_2452_CTAB_20231124171753.csv"),
                      delim = ";")

pl_hospitals <- raw_csv %>% 
  select(-c(Code, `...22`)) %>% 
  rename(regionname = Name)

# Rename columns to year
year_names <- as.character(2004:2022)
current_names <- colnames(pl_hospitals) # Getting the current column names
current_names[2:20] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_hospitals) <- current_names # Assigning the new names back to the dataframe

# More preprocessing
pl_hospitals <- pl_hospitals %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>%
  left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Mazowieckie" ~ "PL92",
                             regionname == "City With Powiat Status Capital City Warszawa" ~ "PL91",
                             T ~ NUTS_ID)) %>%
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "hospitals") %>% 
  mutate(year = as.numeric(year))

# Merge
pl_hospital_beds <- pl_hospital_beds %>% 
  left_join(pl_hospitals, by = c("year", "NUTS_ID"))

pl_hospitals <- pl_hospital_beds
rm(pl_hospital_beds)


## Population ----------------------------

load(here("data", "02_external_emigration", "pl", "pl_population.Rda"))

# pl_hospitals <- pl_hospitals %>%
#   left_join(pl_population, by = c("year", "NUTS_ID")) %>%
#   mutate(ratio_hospital_beds = population / hospital_beds) %>% 
#   mutate(ratio_hospitals = population / hospitals)


## Population over 70 ---------------------

# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 24 November 2023)
raw_csv <- read_delim(here("data", "03_service_cuts", "pl", "LUDN_2137_CTAB_20231124163639.csv"),
                      delim = ";")

pl_population_over_70 <- raw_csv %>% 
  select(-c(Code, `...31`)) %>% 
  rename(regionname = Name) 

# Rename columns to year
year_names <- as.character(1995:2022)
current_names <- colnames(pl_population_over_70) # Getting the current column names
current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_population_over_70) <- current_names # Assigning the new names back to the dataframe
pl_population_over_70 <- pl_population_over_70 %>% select(-c(`1995`, `1996`, `1997`))

# More preprocessing
pl_population_over_70 <- pl_population_over_70 %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>%
  left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Mazowieckie" ~ "PL92",
                             regionname == "City With Powiat Status Capital City Warszawa" ~ "PL91",
                             T ~ NUTS_ID)) %>%
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population_over_70") %>% 
  mutate(year = as.numeric(year))

pl_hospitals <- pl_hospitals %>% 
  # General Population
  left_join(pl_population, by = c("year", "NUTS_ID")) %>% 
  mutate(ratio_hospital_beds_all_population = population / hospital_beds) %>% 
  mutate(ratio_hospitals_all_population = population / hospitals) %>% 
  # Population over 70
  left_join(pl_population_over_70, by = c("year", "NUTS_ID")) %>% 
  mutate(ratio_hospital_beds_population_over_70 = population_over_70 / hospital_beds) %>%
  mutate(ratio_hospitals_population_over_70 = population_over_70 / hospitals)


## Calculate ratio between elections --------------------------------

# Calculate average ratio between elections
# E.g. average of 2001, 2002, 2003 and 2004 for election in 2005

pl_hospitals <- pl_hospitals %>% 
  mutate(ratio_hospitals_diff = c(NA, diff(ratio_hospitals_all_population)))

avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(pl_election_years) - 1)) {
  start_year <- pl_election_years[i]
  end_year <- pl_election_years[i + 1]
  
  # Filter and average classrooms
  avg_data <- pl_hospitals %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(average_ratio_hospitals_election_year = mean(ratio_hospitals_diff, na.rm = T))
  
  avg_data$start_year <- start_year
  avg_data$end_year <- end_year - 1
  
  # Append to the results dataframe
  avg_results <- rbind(avg_results, avg_data)
}

avg_results <- avg_results %>% 
  rename(election_year = end_year) %>% 
  mutate(election_year = election_year + 1) %>% 
  select(NUTS_ID, average_ratio_hospitals_election_year, election_year)

pl_hospitals <- pl_hospitals %>% 
  left_join(avg_results, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year")) %>% 
  distinct(NUTS_ID, year, .keep_all = T)


## Calculate number of hospital change between elections --------------------------------

# Calculate average change between elections
# E.g. average of 2001, 2002, 2003 and 2004 for election in 2005

pl_hospitals <- pl_hospitals %>% 
  mutate(hospitals_diff = c(NA, diff(hospitals)))

avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(pl_election_years) - 1)) {
  start_year <- pl_election_years[i]
  end_year <- pl_election_years[i + 1]
  
  # Filter and average classrooms
  avg_data <- pl_hospitals %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(average_hospitals_diff_election_year = mean(hospitals_diff, na.rm = T))
  
  avg_data$start_year <- start_year
  avg_data$end_year <- end_year - 1
  
  # Append to the results dataframe
  avg_results <- rbind(avg_results, avg_data)
}

avg_results <- avg_results %>% 
  rename(election_year = end_year) %>% 
  mutate(election_year = election_year + 1) %>% 
  select(NUTS_ID, average_hospitals_diff_election_year, election_year)

pl_hospitals <- pl_hospitals %>% 
  left_join(avg_results, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Export ------------------------------

save(pl_hospitals, file = here("data", "03_service_cuts", "pl", "pl_hospitals.Rda"))
