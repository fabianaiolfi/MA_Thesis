
# Lithuania -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://osp.stat.gov.lt/statistiniu-rodikliu-analize#/ (retrieved 9 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "lt", "emigration.csv"))

lt_emigration <- raw_csv %>% 
  select(-Indicator, -Unit) %>% 
  rename(year = Time,
         regionname = `Administrative territory`,
         emigration = Value) %>% 
  drop_na(emigration) %>% 
  mutate(NUTS_ID = case_when(regionname == "Vilnius county" ~ "LT011",
                             regionname == "Alytus county" ~ "LT021",
                             regionname == "Kaunas county" ~ "LT022",
                             regionname == "Klaipėda county" ~ "LT023",
                             regionname == "Marijampolė county" ~ "LT024",
                             regionname == "Panevėžys county" ~ "LT025",
                             regionname == "Šiauliai county" ~ "LT026",
                             regionname == "Tauragė county" ~ "LT027",
                             regionname == "Telšiai county" ~ "LT028",
                             regionname == "Utena county" ~ "LT029")) %>% 
  select(-regionname)


## Population -------------------------------------------------------------

# Source: https://osp.stat.gov.lt/statistiniu-rodikliu-analize#/ (retrieved 9 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "lt", "population.csv"))

lt_population <- raw_csv %>% 
  select(-c(Indicator, `Place of residence`, Unit)) %>% 
  rename(year = Time,
         regionname = `Administrative territory`,
         population = Value) %>% 
  dplyr::filter(regionname != "Republic of Lithuania",
                regionname != "Central and Western Lithuania Region",
                regionname != "Capital Region") %>% 
  mutate(NUTS_ID = case_when(regionname == "Vilnius county" ~ "LT011",
                             regionname == "Alytus county" ~ "LT021",
                             regionname == "Kaunas county" ~ "LT022",
                             regionname == "Klaipėda county" ~ "LT023",
                             regionname == "Marijampolė county" ~ "LT024",
                             regionname == "Panevėžys county" ~ "LT025",
                             regionname == "Šiauliai county" ~ "LT026",
                             regionname == "Tauragė county" ~ "LT027",
                             regionname == "Telšiai county" ~ "LT028",
                             regionname == "Utena county" ~ "LT029")) %>% 
  select(-regionname)


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

lt <- lt_emigration %>%
  left_join(lt_population, by = c("NUTS_ID", "year")) %>% 
  mutate(emigration_yearly_per_1000 = (emigration/population) * 1000) %>% 
  select(NUTS_ID, year, emigration_yearly_per_1000)


## Export ------------------------------

save(lt, file = here("data", "02_external_emigration", "lt", "lt.Rda"))
