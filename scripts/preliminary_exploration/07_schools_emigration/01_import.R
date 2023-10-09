
# Data Import and Preprocessing -------------------------------------------------------------

# Crude rate of net migration plus statistical adjustment [CNMIGRATRT]
# https://ec.europa.eu/eurostat/databrowser/view/DEMO_R_GIND3__custom_7029377/default/table?lang=en
# https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm
# Crude rate of net migration including statistical adjustment is the ratio of the net migration including statistical adjustment during the year to the average population in that year. The value is expressed per 1000 inhabitants. The crude rate of net migration is equal to the difference between the crude rate of population change and the crude rate of natural change (that is, net migration is considered as the part of population change not attributable to births and deaths). It is calculated in this way because immigration or emigration flows are either not available or the figures are not reliable.
net_migr_nuts3 <- read_csv(here("data", "demo_r_gind3_spreadsheet_sheet_2.csv"),
                           na = ":",
                           show_col_types = FALSE)

# Croatia
hr_number_of_primary_schools <- read_csv(here("data", "hr_number_of_primary_schools.csv"))

hr_number_of_primary_schools <- hr_number_of_primary_schools %>% 
  pivot_longer(
    cols = year_2005:year_2019,      # The columns to reshape
    names_to = "year",         # The name of the new column for the year
    values_to = "schools"        # The name of the new column for the values
  ) %>% 
  mutate(year = gsub("year_", "", year)) %>% 
  mutate(year = as.numeric(year))

net_migr_nuts3_hr_long <- net_migr_nuts3 %>% 
  dplyr::filter(str_detect(`GEO (Codes)`, "HR")) %>% 
  dplyr::filter(str_length(`GEO (Codes)`) == 5) %>%
  rename(NUTS3 = `GEO (Codes)`)

# Based on https://ec.europa.eu/eurostat/web/nuts/background, https://ec.europa.eu/eurostat/documents/345175/629341/
net_migr_nuts3_hr_long <- net_migr_nuts3_hr_long %>% 
  mutate(NUTS3 = case_when(NUTS3 == "HR031" ~ "HR031",
                           NUTS3 == "HR032" ~ "HR032",
                           NUTS3 == "HR033" ~ "HR033",
                           NUTS3 == "HR034" ~ "HR034",
                           NUTS3 == "HR035" ~ "HR035",
                           NUTS3 == "HR036" ~ "HR036",
                           NUTS3 == "HR037" ~ "HR037",
                           NUTS3 == "HR041" ~ "HR050",
                           NUTS3 == "HR046" ~ "HR061",
                           NUTS3 == "HR044" ~ "HR062",
                           NUTS3 == "HR045" ~ "HR063",
                           NUTS3 == "HR043" ~ "HR064",
                           NUTS3 == "HR042" ~ "HR065",
                           NUTS3 == "HR047" ~ "HR021",
                           NUTS3 == "HR048" ~ "HR022",
                           NUTS3 == "HR049" ~ "HR023",
                           NUTS3 == "HR04A" ~ "HR024",
                           NUTS3 == "HR04B" ~ "HR025",
                           NUTS3 == "HR04C" ~ "HR026",
                           NUTS3 == "HR04D" ~ "HR027",
                           NUTS3 == "HR04E" ~ "HR028",
                           T ~ NUTS3)) %>% 
  group_by(NUTS3) %>%
  summarise(across(`2000`:`2021`, ~coalesce(.x[1], .x[2], .x), .names = "year_{.col}")) %>% 
  distinct(NUTS3, .keep_all = T) %>% 
  select(-year_2000, -year_2001, -year_2002, -year_2003, -year_2004, -year_2020, -year_2021) %>% 
  pivot_longer(
    cols = year_2005:year_2019,      # The columns to reshape
    names_to = "year",         # The name of the new column for the year
    values_to = "net_migration"        # The name of the new column for the values
  ) %>% 
  mutate(year = gsub("year_", "", year)) %>% 
  mutate(year = as.numeric(year))

hr_schools_emigration <- hr_number_of_primary_schools %>% 
  left_join(net_migr_nuts3_hr_long, by = c("NUTS" = "NUTS3", "year" = "year"))