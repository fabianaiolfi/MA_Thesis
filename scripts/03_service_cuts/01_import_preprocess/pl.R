
# Poland -------------------------------------------------------------


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

pl_schools <- pl_schools %>%
  group_by(NUTS_ID) %>%
  arrange(NUTS_ID, year) %>%
  mutate(schools_diff = schools - dplyr::lag(schools))


## Export ------------------------------

save(pl_schools, file = here("data", "03_service_cuts", "pl", "pl_schools.Rda"))
