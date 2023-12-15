
# Schools --------------------------------

## Schools at NUTS3 --------------------------------

# Source: https://podaci.dzs.hr/media/3uciakvi/obrazovanje.xlsx (Retrieved 15 December 2023)
raw_data <- read_excel(here("data", "03_service_cuts", "hr", "obrazovanje.xlsx"), sheet = "8.1.2.")

# Schools
hr_schools <- raw_data %>% 
  select(-`8.1.2.`, -c(`...21`:`...39`)) %>%
  slice(6:n())

year_names <- as.character(2005:2022)
current_names <- colnames(hr_schools) # Getting the current column names
current_names[2:19] <- year_names # Replacing the names of columns 2 through 29
colnames(hr_schools) <- current_names # Assigning the new names back to the dataframe

hr_schools <- hr_schools %>% 
  slice(3:n()) %>% 
  rename(region = `...2`) %>% 
  mutate(NUTS_ID = case_when(region == "Sisak-Moslavina" ~ "HR04E",
                             region == "Karlovac" ~ "HR04D",
                             region == "Varaždin" ~ "HR044",
                             region == "Koprivnica-Križevci" ~ "HR045",
                             region == "Bjelovar-Bilogora" ~ "HR047",
                             region == "Primorje-Gorski kotar" ~ "HR031",
                             region == "Lika-Senj" ~ "HR032",
                             region == "Virovitica-Podravina" ~ "HR048",
                             region == "Požega-Slavonia" ~ "HR049",
                             region == "Slavonski Brod-Posavina" ~ "HR04A",
                             region == "Zadar" ~ "HR033",
                             region == "Osijek-Baranja" ~ "HR04B",
                             region == "Šibenik-Knin" ~ "HR034",
                             region == "Vukovar-Sirmium" ~ "HR04C",
                             region == "Split-Dalmatia" ~ "HR035",
                             region == "Istria" ~ "HR036",
                             region == "Dubrovnik-Neretva" ~ "HR037",
                             region == "Međimurje" ~ "HR046",
                             region == "City of Zagreb" ~ "HR041",
                             region == "Zagreb" ~ "HR042",
                             region == "Krapina-Zagorje" ~ "HR043")) %>% 
  select(-region) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "schools") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(schools = as.numeric(schools))

# School population
hr_schools_pop <- raw_data %>% 
  select(-`8.1.2.`, -c(`...3`:`...21`)) %>%
  slice(6:n())

year_names <- as.character(2005:2022)
current_names <- colnames(hr_schools_pop) # Getting the current column names
current_names[2:19] <- year_names # Replacing the names of columns 2 through 29
colnames(hr_schools_pop) <- current_names # Assigning the new names back to the dataframe

hr_schools_pop <- hr_schools_pop %>% 
  slice(3:n()) %>% 
  rename(region = `...2`) %>% 
  mutate(NUTS_ID = case_when(region == "Sisak-Moslavina" ~ "HR04E",
                             region == "Karlovac" ~ "HR04D",
                             region == "Varaždin" ~ "HR044",
                             region == "Koprivnica-Križevci" ~ "HR045",
                             region == "Bjelovar-Bilogora" ~ "HR047",
                             region == "Primorje-Gorski kotar" ~ "HR031",
                             region == "Lika-Senj" ~ "HR032",
                             region == "Virovitica-Podravina" ~ "HR048",
                             region == "Požega-Slavonia" ~ "HR049",
                             region == "Slavonski Brod-Posavina" ~ "HR04A",
                             region == "Zadar" ~ "HR033",
                             region == "Osijek-Baranja" ~ "HR04B",
                             region == "Šibenik-Knin" ~ "HR034",
                             region == "Vukovar-Sirmium" ~ "HR04C",
                             region == "Split-Dalmatia" ~ "HR035",
                             region == "Istria" ~ "HR036",
                             region == "Dubrovnik-Neretva" ~ "HR037",
                             region == "Međimurje" ~ "HR046",
                             region == "City of Zagreb" ~ "HR041",
                             region == "Zagreb" ~ "HR042",
                             region == "Krapina-Zagorje" ~ "HR043")) %>% 
  select(-region) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(population = as.numeric(population))


## Schools Merge ------------------------------

hr_schools <- hr_schools %>% 
  left_join(hr_schools_pop, by = c("NUTS_ID", "year")) %>% 
  distinct(NUTS_ID, year, .keep_all = T) %>% 
  mutate(ratio_schools = population / schools)


## Export ------------------------------

save(hr_schools, file = here("data", "03_service_cuts", "hr", "hr_schools.Rda"))
