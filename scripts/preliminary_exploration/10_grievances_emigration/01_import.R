

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
net_migr_nuts3_2012 <- net_migr_nuts3 %>% 
  rename(nuts = `GEO (Codes)`) %>% 
  select(nuts, `2012`) %>% 
  mutate(avg_migration = rowMeans(select(., -nuts))) %>% 
  select(nuts, avg_migration)

net_migr_nuts3_2016 <- net_migr_nuts3 %>% 
  rename(nuts = `GEO (Codes)`) %>% 
  select(nuts, `2016`) %>% 
  mutate(avg_migration = rowMeans(select(., -nuts))) %>% 
  select(nuts, avg_migration)

net_migr_nuts3_2018 <- net_migr_nuts3 %>% 
  rename(nuts = `GEO (Codes)`) %>% 
  select(nuts, `2018`) %>% 
  mutate(avg_migration = rowMeans(select(., -nuts))) %>% 
  select(nuts, avg_migration)

net_migr_nuts3_2019 <- net_migr_nuts3 %>% 
  rename(nuts = `GEO (Codes)`) %>% 
  select(nuts, `2019`) %>% 
  mutate(avg_migration = rowMeans(select(., -nuts))) %>% 
  select(nuts, avg_migration) %>% 
  # Based on https://ec.europa.eu/eurostat/web/nuts/background, https://ec.europa.eu/eurostat/documents/345175/629341/
  mutate(nuts = case_when(nuts == "HR031" ~ "HR031",
                            nuts == "HR032" ~ "HR032",
                            nuts == "HR033" ~ "HR033",
                            nuts == "HR034" ~ "HR034",
                            nuts == "HR035" ~ "HR035",
                            nuts == "HR036" ~ "HR036",
                            nuts == "HR037" ~ "HR037",
                            nuts == "HR041" ~ "HR050",
                            nuts == "HR046" ~ "HR061",
                            nuts == "HR044" ~ "HR062",
                            nuts == "HR045" ~ "HR063",
                            nuts == "HR043" ~ "HR064",
                            nuts == "HR042" ~ "HR065",
                            nuts == "HR047" ~ "HR021",
                            nuts == "HR048" ~ "HR022",
                            nuts == "HR049" ~ "HR023",
                            nuts == "HR04A" ~ "HR024",
                            nuts == "HR04B" ~ "HR025",
                            nuts == "HR04C" ~ "HR026",
                            nuts == "HR04D" ~ "HR027",
                            nuts == "HR04E" ~ "HR028",
                            T ~ nuts)) %>% 
  drop_na(avg_migration)
