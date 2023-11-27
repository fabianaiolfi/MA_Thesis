
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
  mutate(third_places = restaurants + bars)


## Population ----------------------------

load(here("data", "02_external_emigration", "pl", "pl_population.Rda"))
  

## Ratio of Third Places ----------------------------

pl_third_places <- pl_third_places %>% 
  left_join(pl_population, by = c("NUTS_ID", "year")) %>% 
  mutate(ratio_third_places = population / third_places) %>% 
  mutate(ratio_bars = population / bars)


## Export ------------------------------

save(pl_third_places, file = here("data", "03_service_cuts", "pl", "pl_third_places.Rda"))
