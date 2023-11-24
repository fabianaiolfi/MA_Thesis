
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

# pl_schools <- pl_schools %>%
#   group_by(NUTS_ID) %>%
#   arrange(NUTS_ID, year) %>%
#   mutate(schools_diff = schools - dplyr::lag(schools))


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
# 
# ggplot(pl_school_pop, aes(x = year, y = population, line = NUTS_ID)) +
#   geom_line() +
#   theme_minimal()

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

# ggplot(pl_school_pop, aes(x = year, y = population, line = NUTS_ID)) +
#   geom_line() +
#   theme_minimal()


## Schools Merge ------------------------------

pl_schools <- pl_schools %>% 
  left_join(pl_school_pop, by = c("NUTS_ID", "year")) %>% 
  distinct(NUTS_ID, year, .keep_all = T) %>% 
  mutate(ratio_schools = population / schools)

# ggplot(pl_schools, aes(x = year, y = ratio, line = NUTS_ID)) +
#   geom_line() +
#   theme_minimal()


## Export ------------------------------

save(pl_schools, file = here("data", "03_service_cuts", "pl", "pl_schools.Rda"))


# Hospitals ------------------------------

# Hospital Beds
raw_csv <- read_csv(here("data", "03_service_cuts", "pl", "hlth_rs_bdsrg__custom_8678583_linear.csv"))

pl_hospitals <- raw_csv %>% 
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

# Hospitals
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
#pl_hospitals <- pl_hospitals %>% select(-c(`1995`, `1996`, `1997`))

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

ggplot(pl_hospitals, aes(x = year, y = hospitals, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()


# load(here("data", "02_external_emigration", "pl", "pl_population.Rda"))

# pl_hospitals <- pl_hospitals %>% 
#   left_join(pl_population, by = c("year", "NUTS_ID")) %>% 
#   mutate(ratio_hospital_beds = population / hospital_beds)

# ggplot(test, aes(x = year, y = ratio, line = NUTS_ID)) +
#   geom_line() +
#   theme_minimal()

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
  left_join(pl_population, by = c("year", "NUTS_ID")) %>% 
  mutate(ratio_hospital_beds_all_population = population / hospital_beds) %>% 
  left_join(pl_population_over_70, by = c("year", "NUTS_ID")) %>% 
  mutate(ratio_hospital_beds_population_over_70 = population_over_70 / hospital_beds)

ggplot(pl_hospitals, aes(x = year, y = ratio_hospital_beds_population_over_70, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()


## Export ------------------------------

save(pl_hospitals, file = here("data", "03_service_cuts", "pl", "pl_hospitals.Rda"))
