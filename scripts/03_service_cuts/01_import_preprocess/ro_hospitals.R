
# Hospitals --------------------------------

## Hospitals at NUTS3 --------------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (Retrieved 18 December 2023)
raw_data <- read_excel(here("data", "03_service_cuts", "ro", "TEMPO_SAN101A_18_12_2023.xlsx")) # Manually converted .xls to .xlsx

# Hospital Beds
ro_hospitals <- raw_data %>% 
  select(-c(1, 2))

year_names <- as.character(1990:2022)
current_names <- colnames(ro_hospitals) # Getting the current column names
current_names[2:34] <- year_names # Replacing the names of columns 2 through 29
colnames(ro_hospitals) <- current_names # Assigning the new names back to the dataframe

ned_v_dem_ro <- ned_v_dem_cee %>% select(country, regionname, nuts2016) %>% dplyr::filter(country == "Romania") %>% distinct(regionname, .keep_all = T) %>% select(-country)

ro_hospitals <- ro_hospitals %>% 
  slice(8:n()) %>% 
  rename(region = `...3`) %>% 
  drop_na(region) %>% 
  mutate(region = case_when(region == "Bucharest Municipality" ~ "Bucuresti",
                            region == "Bucharest Municipality - including SAI" ~ "Bucuresti",
                            T ~ region)) %>% 
  left_join(ned_v_dem_ro, by = c("region" = "regionname")) %>%
  select(-region) %>% 
  pivot_longer(cols = -nuts2016,
               names_to = "year",
               values_to = "hospitals") %>%
  mutate(year = as.numeric(year)) %>% 
  mutate(hospitals = as.numeric(hospitals)) %>% 
  drop_na(hospitals)


## Hospitals Merge ------------------------------

ro_hospitals <- ro_hospitals %>% 
  left_join(ro_population, by = c("nuts2016" = "NUTS_ID", "year")) %>% 
  distinct(nuts2016, year, .keep_all = T) %>% 
  mutate(ratio_hospitals = population / hospitals) %>% 
  rename(NUTS_ID = nuts2016)


## Export ------------------------------

save(ro_hospitals, file = here("data", "03_service_cuts", "ro", "ro_hospitals.Rda"))
