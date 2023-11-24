
# Schools --------------------------------

## Schools at NUTS2 --------------------------------

# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 20 November 2023)
raw_csv <- read_delim(here("data", "03_service_cuts", "pl", "SZKO_1781_CTAB_20231120214804.csv"),
                      delim = ";")

pl_schools <- raw_csv %>% 
  select(-c(Code, `...31`)) %>% 
  rename(regionname = Name)

# Rename columns to year
year_names <- as.character(1995:2022)
current_names <- colnames(pl_schools) # Getting the current column names
current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_schools) <- current_names # Assigning the new names back to the dataframe
pl_schools <- pl_schools %>% select(-c(`1995`, `1996`, `1997`))

# More preprocessing
pl_schools <- pl_schools %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>%
  left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Mazowieckie" ~ "PL92",
                             regionname == "City With Powiat Status Capital City Warszawa" ~ "PL91",
                             T ~ NUTS_ID)) %>%
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "schools") %>% 
  mutate(year = as.numeric(year))


## Primary school population at NUTS2 --------------------------------
# https://en.wikipedia.org/wiki/Education_in_Poland#Primary_school
# Up to 2017: Age 7 -- 12 (6 years)
# After Sept 2017: Age 7 -- 14 (8 years)

# Age 7 -- 12 from 1998 to 2017
# Source: https://ec.europa.eu/eurostat/databrowser/view/demo_r_d2jan__custom_8622439/default/table?lang=en (retrieved 21 November 2023)
# Problem: 7 NUTS2 regions only from 2014
# raw_csv <- read_csv(here("data", "03_service_cuts", "pl", "demo_r_d2jan__custom_8622439_linear.csv"))
# 
# pl_school_pop_1998_2017 <- raw_csv %>% 
#   select(age, geo, TIME_PERIOD, OBS_VALUE) %>% 
#   dplyr::filter(str_detect(geo, "^PL\\d\\d")) %>%  # Filter for NUTS2 (PL and 2 digits)
#   group_by(TIME_PERIOD, geo) %>% 
#   summarise(population = sum(OBS_VALUE))

# Age 7 -- 12 from 1998 to 2017
# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 21 November 2023)
# raw_csv <- read_delim(here("data", "03_service_cuts", "pl", "LUDN_1341_CTAB_20231121184439.csv"),
#                       delim = ";")
# 
# pl_school_pop_1998_2017 <- raw_csv %>% 
#   select(-c(Code, `...141`)) %>% 
#   rename(regionname = Name) %>% 
#   rename_with(~gsub("total;([0-9]+);([0-9]+);\\[person\\]", "age_\\1_year_\\2", .)) # Rename columns

# More preprocessing
# pl_school_pop_1998_2017 <- pl_school_pop_1998_2017 %>% 
#   mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>%
#   left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
#   mutate(NUTS_ID = case_when(regionname == "Mazowieckie" ~ "PL92",
#                              regionname == "City With Powiat Status Capital City Warszawa" ~ "PL91",
#                              T ~ NUTS_ID)) %>%
#   select(-regionname) %>% 
#   pivot_longer(cols = -NUTS_ID,
#                names_to = "year",
#                values_to = "population") %>% 
#   mutate(year = gsub("age_\\d+_year_", "", year)) %>% 
#   mutate(year = as.numeric(year)) %>% 
#   group_by(year, NUTS_ID) %>% 
#   mutate(population = sum(population))

# Age 7 -- 14 from 2018 to 2022
# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 21 November 2023)
# raw_csv <- read_delim(here("data", "03_service_cuts", "pl", "LUDN_1341_CTAB_20231121190207.csv"),
#                       delim = ";")
# 
# pl_school_pop_2018_2022 <- raw_csv %>% 
#   select(-c(Code, `...43`)) %>% 
#   rename(regionname = Name) %>% 
#   rename_with(~gsub("total;([0-9]+);([0-9]+);\\[person\\]", "age_\\1_year_\\2", .)) # Rename columns
# 
# # More preprocessing
# pl_school_pop_2018_2022 <- pl_school_pop_2018_2022 %>% 
#   mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>%
#   left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
#   mutate(NUTS_ID = case_when(regionname == "Mazowieckie" ~ "PL92",
#                              regionname == "City With Powiat Status Capital City Warszawa" ~ "PL91",
#                              T ~ NUTS_ID)) %>%
#   select(-regionname) %>% 
#   pivot_longer(cols = -NUTS_ID,
#                names_to = "year",
#                values_to = "population") %>% 
#   mutate(year = gsub("age_\\d+_year_", "", year)) %>% 
#   mutate(year = as.numeric(year)) %>% 
#   group_by(year, NUTS_ID) %>% 
#   mutate(population = sum(population))
# 
# # Merging these results in a jump/break between 2017/2018
# pl_school_pop <- pl_school_pop_1998_2017 %>% 
#   bind_rows(pl_school_pop_2018_2022)

# Fix: Only take age 7--12 for all years
raw_csv <- read_delim(here("data", "03_service_cuts", "pl", "LUDN_1341_CTAB_20231121190646.csv"),
                      delim = ";")

pl_school_pop <- raw_csv %>% 
  select(-c(Code, `...171`)) %>% 
  rename(regionname = Name) %>% 
  rename_with(~gsub("total;([0-9]+);([0-9]+);\\[person\\]", "age_\\1_year_\\2", .)) # Rename columns

# More preprocessing
pl_school_pop <- pl_school_pop %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>%
  left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Mazowieckie" ~ "PL92",
                             regionname == "City With Powiat Status Capital City Warszawa" ~ "PL91",
                             T ~ NUTS_ID)) %>%
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population") %>% 
  mutate(year = gsub("age_\\d+_year_", "", year)) %>% 
  mutate(year = as.numeric(year)) %>% 
  group_by(year, NUTS_ID) %>% 
  mutate(population = sum(population))


## Schools Merge ------------------------------

pl_schools <- pl_schools %>% 
  left_join(pl_school_pop, by = c("NUTS_ID", "year")) %>% 
  distinct(NUTS_ID, year, .keep_all = T) %>% 
  mutate(ratio_schools = population / schools)


## Export ------------------------------

save(pl_schools, file = here("data", "03_service_cuts", "pl", "pl_schools.Rda"))
