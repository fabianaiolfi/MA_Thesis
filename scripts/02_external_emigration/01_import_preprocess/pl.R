
# Poland -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 10 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "pl", "LUDN_1350_CTAB_20231110071448.csv"),
                      delim = ";")#,
                      #skip = 1)
 
pl_emigration <- raw_csv %>%
  select(-c(Code, `...31`)) %>% 
  rename(regionname = Name)

# Rename columns to year
year_names <- as.character(1995:2022)
current_names <- colnames(pl_emigration) # Getting the current column names
current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_emigration) <- current_names # Assigning the new names back to the dataframe

pl_emigration <- pl_emigration %>% 
  dplyr::filter(str_detect(regionname, "SUBREGION")) %>% 
  mutate(regionname = gsub("SUBREGION ", "", regionname))


## Population -------------------------------------------------------------

# Source: …
raw_csv <- read_delim(here("data", "02_external_emigration", "pl", "…"),
                      delim = ";",
                      skip = 1)

plv_population <- raw_csv %>% 
  #…


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

pl <- pl_emigration %>%
  left_join(pl_population, by = c("NUTS_ID", "year")) %>% 
  mutate(crude_emigration = (emigration/population) * 1000)


## Export ------------------------------

save(pl, file = here("data", "02_external_emigration", "pl", "pl.Rda"))
