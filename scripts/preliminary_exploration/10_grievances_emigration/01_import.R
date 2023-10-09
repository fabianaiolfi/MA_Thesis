

# Import -------------------------------------------------------------

## ESS -------------------------------------------------------------

ess <- read_dta(here("data", "ESS-Data-Wizard-subset-2023-10-09.dta"))

# Preprocessing
ess_subset <- ess %>% 
  select(essround, anweight, region, happy) %>% 
  drop_na()


## Crude rate of net migration plus statistical adjustment [CNMIGRATRT] -------------------------------------------------------------

# https://ec.europa.eu/eurostat/databrowser/view/DEMO_R_GIND3__custom_7029377/default/table?lang=en
# https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm
# Crude rate of net migration including statistical adjustment is the ratio of the net migration including statistical adjustment during the year to the average population in that year. The value is expressed per 1000 inhabitants. The crude rate of net migration is equal to the difference between the crude rate of population change and the crude rate of natural change (that is, net migration is considered as the part of population change not attributable to births and deaths). It is calculated in this way because immigration or emigration flows are either not available or the figures are not reliable.
net_migr_nuts3 <- read_csv(here("data", "demo_r_gind3_spreadsheet_sheet_2.csv"),
                           na = ":",
                           show_col_types = FALSE)

# Preprocessing
net_migr_nuts3_2008_2012 <- net_migr_nuts3 %>% 
  rename(nuts = `GEO (Codes)`,
         nuts_name = `GEO (Labels)`) %>% 
  select(nuts, nuts_name, `2010`, `2011`, `2012`) %>% 
  mutate(avg_migration = rowMeans(select(., -nuts, -nuts_name))) %>% 
  select(nuts, nuts_name, avg_migration)

net_migr_nuts3_2012_2016 <- net_migr_nuts3 %>% 
  rename(nuts = `GEO (Codes)`,
         nuts_name = `GEO (Labels)`) %>% 
  select(nuts, nuts_name, `2014`, `2015`, `2016`) %>% 
  mutate(avg_migration = rowMeans(select(., -nuts, -nuts_name))) %>% 
  select(nuts, nuts_name, avg_migration)

net_migr_nuts3_2014_2018 <- net_migr_nuts3 %>% 
  rename(nuts = `GEO (Codes)`,
         nuts_name = `GEO (Labels)`) %>% 
  select(nuts, nuts_name, `2016`, `2017`, `2018`) %>% 
  mutate(avg_migration = rowMeans(select(., -nuts, -nuts_name))) %>% 
  select(nuts, nuts_name, avg_migration)

net_migr_nuts3_2016_2020 <- net_migr_nuts3 %>% 
  rename(nuts = `GEO (Codes)`,
         nuts_name = `GEO (Labels)`) %>% 
  select(nuts, nuts_name, `2017`, `2018`, `2019`) %>% 
  mutate(avg_migration = rowMeans(select(., -nuts, -nuts_name))) %>% 
  select(nuts, nuts_name, avg_migration)
