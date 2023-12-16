
# Third Places --------------------------------

## Third Places at NUTS3 --------------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (Retrieved 15 December 2023)
raw_data <- read_excel(here("data", "03_service_cuts", "ro", "TEMPO_INT101U_15_12_2023.xlsx")) # Manually converted .xls to .xlsx

# Hospital Beds
ro_third_places <- raw_data %>% 
  select(-c(1, 2))

year_names <- as.character(2008:2021)
current_names <- colnames(ro_third_places) # Getting the current column names
current_names[2:15] <- year_names # Replacing the names of columns 2 through 29
colnames(ro_third_places) <- current_names # Assigning the new names back to the dataframe

ro_nuts2 <- c("CENTER", "MACROREGION 2", "NORTH - EAST", "SOUTH - EAST", "MACROREGION 3", "SOUTH - MUNTENIA", "BUCHAREST - ILFOV", "MACROREGION 4", "SOUTH - WEST OLTENIA", "WEST")
ned_v_dem_ro <- ned_v_dem_cee %>% select(country, regionname, nuts2016) %>% dplyr::filter(country == "Romania") %>% distinct(regionname, .keep_all = T) %>% select(-country)

ro_third_places <- ro_third_places %>% 
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


## Third Places Merge ------------------------------

ro_third_places <- ro_third_places %>% 
  left_join(ro_population, by = c("nuts2016" = "NUTS_ID", "year")) %>% 
  distinct(nuts2016, year, .keep_all = T) %>% 
  mutate(ratio_third_places = population / third_places) %>% 
  rename(NUTS_ID = nuts2016)


## Export ------------------------------

save(ro_third_places, file = here("data", "03_service_cuts", "ro", "ro_third_places.Rda"))
