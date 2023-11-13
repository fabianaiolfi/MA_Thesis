
# Slovenia -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://pxweb.stat.si/SiStatData/pxweb/en/Data/Data/05N1042S.px/table/tableViewLayout2/ (retrieved 10 November 2023)
# Converted from Windows 1252 to UTF8
raw_csv <- read_delim(here("data", "02_external_emigration", "si", "05N1042S_20231110-081535_utf8.csv"), skip = 1)

si_emigration <- raw_csv %>% 
  rename(regionname = `STATISTICAL REGION`)

# Rename columns to year
year_names <- as.character(2000:2022)
current_names <- colnames(si_emigration) # Getting the current column names
current_names[2:24] <- year_names # Replacing the names of columns 2 through 29
colnames(si_emigration) <- current_names # Assigning the new names back to the dataframe

# Further preprocessing and add NUTS3 ID
si_emigration <- si_emigration %>% 
  left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  drop_na(NUTS_ID) %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "emigration") %>% 
  mutate(year = as.numeric(year))


## Population -------------------------------------------------------------

# Source: https://pxweb.stat.si/SiStatData/pxweb/en/Data/Data/05E1016S.px/table/tableViewLayout2/ (retrieved 10 November 2023)
# Converted from Windows 1252 to UTF8
raw_csv <- read_delim(here("data", "02_external_emigration", "si", "05E1016S_20231110-081946_utf8.csv"), skip = 1)

si_population <- raw_csv %>% 
  rename(regionname = `STATISTICAL REGION`,
         year = `HALF-YEAR`,
         population = `Population Sex - TOTAL`) %>% 
  dplyr::filter(str_detect(year, "H1")) %>% 
  mutate(year = gsub("H1", "", year)) %>% 
  mutate(year = as.numeric(year)) %>% 
  left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  drop_na(NUTS_ID) %>% 
  select(-regionname)


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

si <- si_emigration %>%
  left_join(si_population, by = c("NUTS_ID", "year")) %>% 
  mutate(crude_emigration = (emigration/population) * 1000)


## Export ------------------------------

save(si, file = here("data", "02_external_emigration", "si", "si.Rda"))
