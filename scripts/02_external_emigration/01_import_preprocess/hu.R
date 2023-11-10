
# Hungary -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://statinfo.ksh.hu/Statinfo/haViewer.jsp (retrieved 7 November 2023)
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





colnames(hu_emigration)

unique(hu_emigration$year)


unique(hu_emigration$year)
head(hu_emigration)

## Population -------------------------------------------------------------

# Source: …


 
## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

hu <- hu_emigration %>%
  left_join(hu_population, by = c("year", "NUTS_ID")) %>%
  mutate(crude_emigration = (emigration/population) * 1000)


## Export ------------------------------

save(hu, file = here("data", "02_external_emigration", "hu", "hu.Rda"))
