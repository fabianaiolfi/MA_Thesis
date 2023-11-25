
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

# Source: https://www.ksh.hu/stadat_files/nep/en/nep0034.html (retrieved 16 November 2023)
# Original CSV has Windows 1252 encoding, which must be converted to UTF8
raw_csv <- read_delim(here("data", "02_external_emigration", "hu", "stadat-nep0034-22.1.2.1-hu_utf8.csv"),
                      skip = 1)
 
hu_population <- raw_csv %>%
  dplyr::filter(!row_number() %in% c(1:62)) %>% # Remove rows only containing population by gender
  dplyr::filter(grepl("capital|county", `Level of territorial units`)) %>% # Only keep rows contianing county or capital in "level" column
  select(-`Level of territorial units`) %>% 
  rename(regionname = `Name of territorial units`) %>% 
  left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Gyõr-Moson-Sopron" ~ "HU221",
                             regionname == "Csongrád-Csanád" ~ "HU333",
                             T ~ NUTS_ID)) %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population") %>% 
  mutate(population = gsub(" ", "", population)) %>% 
  mutate(year = as.numeric(year),
         population = as.numeric(population))


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

hu <- hu_emigration %>%
  left_join(hu_population, by = c("NUTS_ID", "year")) %>% 
  mutate(emigration_yearly_per_1000 = (emigration/population) * 1000) %>% 
  select(NUTS_ID, year, emigration_yearly_per_1000)


## Export ------------------------------

save(hu, file = here("data", "02_external_emigration", "hu", "hu.Rda"))
