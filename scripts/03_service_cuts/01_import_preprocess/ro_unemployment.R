
# Unemployment --------------------------------

## Unemployment at NUTS3 --------------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (Retrieved 19 January 2024)
raw_data <- read_excel(here("data", "03_service_cuts", "ro", "TEMPO_SOM103A_19_1_2024.xlsx")) # Manually converted .xls to .xlsx

ro_unemployment <- raw_data %>% 
  select(c(`...2`:`...34`))

year_names <- as.character(1991:2022)
current_names <- colnames(ro_unemployment) # Getting the current column names
current_names[2:33] <- year_names # Replacing the names of columns 2 through 29
colnames(ro_unemployment) <- current_names # Assigning the new names back to the dataframe

ro_nuts2 <- c("CENTER", "MACROREGION 2", "NORTH - EAST", "SOUTH - EAST", "MACROREGION 3", "SOUTH - MUNTENIA", "BUCHAREST - ILFOV", "MACROREGION 4", "SOUTH - WEST OLTENIA", "WEST")
ned_v_dem_ro <- ned_v_dem_cee %>% select(country, regionname, nuts2016) %>% dplyr::filter(country == "Romania") %>% distinct(regionname, .keep_all = T) %>% select(-country)

ro_unemployment <- ro_unemployment %>% 
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
               values_to = "unemployment") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(unemployment = as.numeric(unemployment)) %>% 
  drop_na(unemployment)


## Export ------------------------------

save(ro_unemployment, file = here("data", "03_service_cuts", "ro", "ro_unemployment.Rda"))
