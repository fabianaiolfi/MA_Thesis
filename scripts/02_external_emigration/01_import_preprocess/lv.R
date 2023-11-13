
# Latvia -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://data.stat.gov.lv/pxweb/en/OSP_PUB/START__POP__IB__IBE/IBE080/table/tableViewLayout1/ (retrieved 9 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "lv", "IBE080_20231109-184935.csv"),
                      delim = ";",
                      skip = 1)
 
lv_emigration <- raw_csv %>% 
  rename(regioname = `Territorial unit`) %>% 
  select(-Indicator) %>% 
  pivot_longer(
    cols = -regioname, 
    names_to = "year",
    values_to = "emigration") %>% 
  mutate(NUTS_ID = case_when(regioname == "Kurzeme region" ~ "LV003",
                             regioname == "Latgale region" ~ "LV005",
                             regioname == "Riga region" ~ "LV006",
                             regioname == "Pierīga region" ~ "LV007",
                             regioname == "Vidzeme region" ~ "LV008",
                             regioname == "Zemgale region" ~ "LV009")) %>% 
  mutate(year = as.numeric(year)) %>% 
  select(-regioname)


## Population -------------------------------------------------------------

# Source: https://data.stat.gov.lv/pxweb/en/OSP_PUB/START__POP__IR__IRS/IRS030/table/tableViewLayout1/ (retrieved 9 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "lv", "IRS030_20231109-185354.csv"),
                      delim = ";",
                      skip = 1)

lv_population <- raw_csv %>% 
  rename(regioname = `Territorial unit`) %>% 
  select(-Indicator) %>% 
  pivot_longer(
    cols = -regioname, 
    names_to = "year",
    values_to = "population") %>% 
  mutate(NUTS_ID = case_when(regioname == "Kurzeme region" ~ "LV003",
                             regioname == "Latgale region" ~ "LV005",
                             regioname == "Riga region" ~ "LV006",
                             regioname == "Pierīga region" ~ "LV007",
                             regioname == "Vidzeme region" ~ "LV008",
                             regioname == "Zemgale region" ~ "LV009")) %>% 
  mutate(year = as.numeric(year)) %>% 
  select(-regioname)


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

lv <- lv_emigration %>%
  left_join(lv_population, by = c("NUTS_ID", "year")) %>% 
  mutate(crude_emigration = (emigration/population) * 1000)


## Export ------------------------------

save(lv, file = here("data", "02_external_emigration", "lv", "lv.Rda"))