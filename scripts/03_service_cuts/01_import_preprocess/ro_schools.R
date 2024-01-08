
# Schools --------------------------------

## Schools at NUTS3 --------------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (Retrieved 15 December 2023)
raw_data <- read_excel(here("data", "03_service_cuts", "ro", "TEMPO_SCL101A_15_12_2023.xlsx")) # Manually converted .xls to .xlsx

# Schools
ro_schools <- raw_data %>% 
  select(c(`...3`:`...36`))

year_names <- as.character(1990:2022)
current_names <- colnames(ro_schools) # Getting the current column names
current_names[2:34] <- year_names # Replacing the names of columns 2 through 29
colnames(ro_schools) <- current_names # Assigning the new names back to the dataframe

ro_nuts2 <- c("CENTER", "MACROREGION 2", "NORTH - EAST", "SOUTH - EAST", "MACROREGION 3", "SOUTH - MUNTENIA", "BUCHAREST - ILFOV", "MACROREGION 4", "SOUTH - WEST OLTENIA", "WEST")
ned_v_dem_ro <- ned_v_dem_cee %>% select(country, regionname, nuts2016) %>% dplyr::filter(country == "Romania") %>% distinct(regionname, .keep_all = T) %>% select(-country)

ro_schools <- ro_schools %>% 
  slice(8:n()) %>% 
  rename(region = `...3`) %>% 
  drop_na(region) %>% 
  dplyr::filter(!region %in% ro_nuts2) %>% 
  mutate(across(everything(), ~gsub(':', NA, .))) %>% 
  mutate(region = case_when(region == "Bucharest Municipality - including SAI" ~ "Bucuresti",
                            region == "Bucharest Municipality" ~ "Bucuresti",
                            T ~ region)) %>% 
  left_join(ned_v_dem_ro, by = c("region" = "regionname")) %>% 
  select(-region) %>% 
  pivot_longer(cols = -nuts2016,
               names_to = "year",
               values_to = "schools") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(schools = as.numeric(schools)) %>% 
  drop_na(schools)


# School population
raw_data <- read_excel(here("data", "03_service_cuts", "ro", "TEMPO_SCL103E_15_12_2023.xlsx")) # Manually converted .xls to .xlsx

ro_schools_pop <- raw_data %>% 
  select(c(`...3`:`...31`))

year_names <- as.character(1995:2022)
current_names <- colnames(ro_schools_pop) # Getting the current column names
current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
colnames(ro_schools_pop) <- current_names # Assigning the new names back to the dataframe

ro_schools_pop <- ro_schools_pop %>% 
  slice(8:n()) %>% 
  rename(region = `...3`) %>% 
  drop_na(region) %>% 
  dplyr::filter(!region %in% ro_nuts2) %>% 
  mutate(across(everything(), ~gsub(':', NA, .))) %>% 
  mutate(region = case_when(region == "Bucharest Municipality - including SAI" ~ "Bucuresti",
                            region == "Bucharest Municipality" ~ "Bucuresti",
                            T ~ region)) %>% 
  left_join(ned_v_dem_ro, by = c("region" = "regionname")) %>% 
  select(-region) %>% 
  pivot_longer(cols = -nuts2016,
               names_to = "year",
               values_to = "population") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(population = as.numeric(population)) %>% 
  drop_na(population)


## Classrooms ------------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (Retrieved 8 January 2024)
raw_data <- read_excel(here("data", "03_service_cuts", "ro", "TEMPO_SCL105C_8_1_2024.xlsx")) # Manually converted .xls to .xlsx

# Classrooms
ro_classrooms <- raw_data %>% 
  select(c(`...2`:`...35`))

year_names <- as.character(1990:2022)
current_names <- colnames(ro_classrooms) # Getting the current column names
current_names[2:34] <- year_names # Replacing the names of columns 2 through 29
colnames(ro_classrooms) <- current_names # Assigning the new names back to the dataframe

ro_classrooms <- ro_classrooms %>% 
  slice(8:n()) %>% 
  rename(region = `...2`) %>% 
  drop_na(region) %>% 
  dplyr::filter(!region %in% ro_nuts2) %>% 
  mutate(across(everything(), ~gsub(':', NA, .))) %>% 
  mutate(region = case_when(region == "Bucharest Municipality - including SAI" ~ "Bucuresti",
                            region == "Bucharest Municipality" ~ "Bucuresti",
                            T ~ region)) %>% 
  left_join(ned_v_dem_ro, by = c("region" = "regionname")) %>% 
  select(-region) %>% 
  pivot_longer(cols = -nuts2016,
               names_to = "year",
               values_to = "classrooms") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(classrooms = as.numeric(classrooms)) %>% 
  drop_na(classrooms)


## Schools Merge ------------------------------

ro_schools <- ro_schools %>% 
  left_join(ro_schools_pop, by = c("nuts2016", "year")) %>% 
  left_join(ro_classrooms, by = c("nuts2016", "year")) %>% 
  distinct(nuts2016, year, .keep_all = T) %>% 
  mutate(ratio_schools = population / schools) %>% 
  mutate(ratio_classrooms = population / classrooms) %>% 
  rename(NUTS_ID = nuts2016)


## Export ------------------------------

save(ro_schools, file = here("data", "03_service_cuts", "ro", "ro_schools.Rda"))
