
# Hungary -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://statinfo.ksh.hu/Statinfo/haViewer.jsp (retrieved 7 November 2023)
# Original CSV has ISO-8859-2 encoding, which must be converted to UTF8
raw_csv <- read_delim(here("data", "02_external_emigration", "hu", "Hungarian_citizens'_international_migration_utf8.csv"),
                      delim = ";",
                      skip = 6)

hu_emigration <- raw_csv %>% 
  select(-`...4`) %>% 
  rename(year = `Period of time`,
         regionname = `Geographic Area`,
         emigration = `Number of Hungarian citizens emigrating from Hungary (capita)`) %>% 
  mutate(year = gsub("\\. year", "", year)) %>% 
  fill(year) %>% # Fill rows with NAs with year from above row
  mutate(year = as.numeric(year),
         emigration = as.numeric(emigration)) %>% 
  dplyr::filter(regionname != "Pest region") %>% # Identical to "Pest vármegye"
  dplyr::filter(regionname != "Budapest region") %>% # Identical to "Budapest"
  mutate(regionname = gsub(" vármegye", "", regionname)) %>% 
  left_join(cee_nuts3, by = c("regionname" = "NAME_LATN")) %>% 
  select(-regionname) %>% 
  drop_na(NUTS_ID)


## Population -------------------------------------------------------------

# Source: https://statinfo.ksh.hu/Statinfo/haViewer.jsp (retrieved 7 November 2023)
# Original CSV has ISO-8859-2 encoding, which must be converted to UTF8
# Data only cover the years 2013 and 2014
# raw_csv <- read_delim(here("data", "02_external_emigration", "hu", "Calculated_population_data_by_district_utf8.csv"),
#                       delim = ";",
#                       skip = 6)
# 
# hu_population <- raw_csv %>%
#   select(-`...4`) %>%
#   rename(year = `Period of time`,
#          regionname = `Geographic area`,
#          population = `number of population on 1 January (capita)`)# %>%
#   mutate(year = gsub("\\. year", "", year))# %>%
#   fill(year)# %>% # Fill rows with NAs with year from above row
#   mutate(year = as.numeric(year),
#          emigration = as.numeric(emigration)) %>%
#   dplyr::filter(regionname != "Pest region") %>% # Identical to "Pest vármegye"
#   dplyr::filter(regionname != "Budapest region") %>% # Identical to "Budapest"
#   mutate(regionname = gsub(" vármegye", "", regionname)) %>%
#   left_join(cee_nuts3, by = c("regionname" = "NAME_LATN")) %>%
#   select(-regionname) %>%
#   drop_na(NUTS_ID)


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

hu <- hu_emigration %>%
  left_join(nuts3_population, by = c("NUTS_ID", "year")) %>% 
  mutate(crude_emigration = (emigration/population) * 1000) %>% 
  select(NUTS_ID, year, crude_emigration)


## Export ------------------------------

save(hu, file = here("data", "02_external_emigration", "hu", "hu.Rda"))
