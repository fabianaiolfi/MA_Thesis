
# Fertility --------------------------------

## Fertility at NUTS3 --------------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (Retrieved 5 January 2024)
raw_data <- read_excel(here("data", "03_service_cuts", "ro", "TEMPO_POP203A_5_1_2024.xlsx")) # Manually converted .xls to .xlsx

# Hospital Beds
ro_fertility <- raw_data %>% 
  select(-c(1, 2))

year_names <- as.character(1990:2022)
current_names <- colnames(ro_fertility) # Getting the current column names
current_names[2:34] <- year_names # Replacing the names of columns 2 through 29
colnames(ro_fertility) <- current_names # Assigning the new names back to the dataframe

ro_nuts2 <- c("CENTER", "MACROREGION 2", "NORTH - EAST", "SOUTH - EAST", "MACROREGION 3", "SOUTH - MUNTENIA", "BUCHAREST - ILFOV", "MACROREGION 4", "SOUTH - WEST OLTENIA", "WEST")
ned_v_dem_ro <- ned_v_dem_cee %>% select(country, regionname, nuts2016) %>% dplyr::filter(country == "Romania") %>% distinct(regionname, .keep_all = T) %>% select(-country)

ro_fertility <- ro_fertility %>% 
  slice(8:n()) %>% 
  rename(region = `...3`) %>% 
  drop_na(region) %>% 
  dplyr::filter(!region %in% ro_nuts2) %>% 
  mutate(across(everything(), ~gsub(':', NA, .))) %>% 
  mutate(region = case_when(region == "Bucharest Municipality" ~ "Bucuresti",
                            region == "Bucharest Municipality - including SAI" ~ "Bucuresti",
                            T ~ region)) %>% 
  left_join(ned_v_dem_ro, by = c("region" = "regionname")) %>%
  select(-region) %>% 
  pivot_longer(cols = -nuts2016,
               names_to = "year",
               values_to = "fertility") %>%
  mutate(year = as.numeric(year)) %>% 
  mutate(fertility = as.numeric(fertility)) %>% 
  drop_na(fertility)


## Export ------------------------------

save(ro_fertility, file = here("data", "03_service_cuts", "ro", "ro_fertility.Rda"))
