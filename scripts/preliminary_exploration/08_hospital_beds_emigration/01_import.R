

# Universal Variables -------------------------------------------------------------

cee <- c("BG", "HR", "CZ", "EE", "HU", "LV", "LT", "PL", "RO", "SK", "SI")
pattern <- paste(cee, collapse = "|")

# Crude rate of net migration plus statistical adjustment [CNMIGRATRT]
# https://ec.europa.eu/eurostat/databrowser/view/DEMO_R_GIND3__custom_7029377/default/table?lang=en
# https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm
# Crude rate of net migration including statistical adjustment is the ratio of the net migration including statistical adjustment during the year to the average population in that year. The value is expressed per 1000 inhabitants. The crude rate of net migration is equal to the difference between the crude rate of population change and the crude rate of natural change (that is, net migration is considered as the part of population change not attributable to births and deaths). It is calculated in this way because immigration or emigration flows are either not available or the figures are not reliable.
net_migr_nuts3 <- read_csv(here("data", "demo_r_gind3_spreadsheet_sheet_2.csv"),
                           na = ":",
                           show_col_types = FALSE)

# Data Import and Preprocessing -------------------------------------------------------------

## Croatia -------------------------------------------------------------

# All CEE via Eurostat
# hospital_beds <- read_csv(here("data", "tgs00064_linear.csv"))
# 
# hr_hospital_beds <- hospital_beds %>% 
#     select(geo, TIME_PERIOD, OBS_VALUE) %>%
#     dplyr::filter(str_detect(geo, pattern)) %>% 
#   dplyr::filter(str_detect(geo, "HR"))
# 
# 
# net_migr_nuts3_hr_long <- net_migr_nuts3 %>% 
#   dplyr::filter(str_detect(`GEO (Codes)`, "HR")) %>% 
#   dplyr::filter(str_length(`GEO (Codes)`) == 5) %>%
#   rename(NUTS3 = `GEO (Codes)`)
# 
# # Based on https://ec.europa.eu/eurostat/web/nuts/background, https://ec.europa.eu/eurostat/documents/345175/629341/
# net_migr_nuts3_hr_long <- net_migr_nuts3_hr_long %>% 
#   mutate(NUTS3 = case_when(NUTS3 == "HR031" ~ "HR031",
#                            NUTS3 == "HR032" ~ "HR032",
#                            NUTS3 == "HR033" ~ "HR033",
#                            NUTS3 == "HR034" ~ "HR034",
#                            NUTS3 == "HR035" ~ "HR035",
#                            NUTS3 == "HR036" ~ "HR036",
#                            NUTS3 == "HR037" ~ "HR037",
#                            NUTS3 == "HR041" ~ "HR050",
#                            NUTS3 == "HR046" ~ "HR061",
#                            NUTS3 == "HR044" ~ "HR062",
#                            NUTS3 == "HR045" ~ "HR063",
#                            NUTS3 == "HR043" ~ "HR064",
#                            NUTS3 == "HR042" ~ "HR065",
#                            NUTS3 == "HR047" ~ "HR021",
#                            NUTS3 == "HR048" ~ "HR022",
#                            NUTS3 == "HR049" ~ "HR023",
#                            NUTS3 == "HR04A" ~ "HR024",
#                            NUTS3 == "HR04B" ~ "HR025",
#                            NUTS3 == "HR04C" ~ "HR026",
#                            NUTS3 == "HR04D" ~ "HR027",
#                            NUTS3 == "HR04E" ~ "HR028",
#                            T ~ NUTS3))
# 
# # Create NUTS2 Regions
# HR02 <- c("HR021", "HR022", "HR023", "HR024", "HR025", "HR026", "HR027", "HR028")
# HR03 <- c("HR031", "HR032", "HR033", "HR034", "HR035", "HR036", "HR037")
# HR05 <- c("HR050")
# HR06 <- c("HR061", "HR062", "HR063", "HR064", "HR065")
# 
# net_migr_nuts3_hr_long <- net_migr_nuts3_hr_long %>% 
#   mutate(NUTS2 = case_when(NUTS3 %in% HR02 ~ "HR02",
#                            NUTS3 %in% HR03 ~ "HR03",
#                            NUTS3 %in% HR05 ~ "HR05",
#                            NUTS3 %in% HR06 ~ "HR06"))
# 
# net_migr_nuts3_hr_long <- net_migr_nuts3_hr_long %>% 
#   select(-NUTS3, -`GEO (Labels)`) %>% 
#   group_by(NUTS2) %>% 
#   summarise(across(everything(), ~sum(., na.rm = TRUE)))
#   
# net_migr_nuts3_hr_long <- net_migr_nuts3_hr_long %>% 
#   group_by(NUTS2) %>%
#   summarise(across(`2000`:`2021`, ~coalesce(.x[1], .x[2], .x), .names = "year_{.col}")) %>%
#   distinct(NUTS2, .keep_all = T) %>%
#   select(-year_2000, -year_2001, -year_2002, -year_2003, -year_2004, -year_2005, -year_2006, -year_2007, -year_2008, -year_2009, -year_2010, -year_2020, -year_2021) %>%
#   pivot_longer(
#     cols = year_2011:year_2019,      # The columns to reshape
#     names_to = "year",         # The name of the new column for the year
#     values_to = "net_migration"        # The name of the new column for the values
#   ) %>%
#   mutate(year = gsub("year_", "", year)) %>%
#   mutate(year = as.numeric(year))
# 
# hr_merge <- net_migr_nuts3_hr_long %>% 
#   left_join(hr_hospital_beds, by = c("NUTS2" = "geo", "year" = "TIME_PERIOD"))
# 
# plot(hr_merge$net_migration, hr_merge$OBS_VALUE)

# Not enough overlapping data points


## Romania -------------------------------------------------------------

net_migr_nuts3_ro_long <- net_migr_nuts3 %>% 
  dplyr::filter(str_detect(`GEO (Codes)`, "RO")) %>% 
  dplyr::filter(str_length(`GEO (Codes)`) == 5) %>%
  rename(NUTS3 = `GEO (Codes)`)

net_migr_nuts3_ro_long <- net_migr_nuts3_ro_long %>% 
  group_by(NUTS3) %>%
  summarise(across(`2000`:`2022`, ~coalesce(.x[1], .x[2], .x), .names = "year_{.col}")) %>%
  distinct(NUTS3, .keep_all = T) %>%
  pivot_longer(
    cols = year_2000:year_2022,      # The columns to reshape
    names_to = "year",         # The name of the new column for the year
    values_to = "net_migration"        # The name of the new column for the values
  ) %>%
  mutate(year = gsub("year_", "", year)) %>%
  mutate(year = as.numeric(year))

ro_hospital_beds <- read_csv(here("data", "TEMPO_SAN102C_9_10_2023.csv"))

ro_hospital_beds_long <- ro_hospital_beds %>% 
  pivot_longer(
    cols = year_1990:year_2022,      # The columns to reshape
    names_to = "year",         # The name of the new column for the year
    values_to = "nr_of_beds"        # The name of the new column for the values
  ) %>%
    mutate(year = gsub("year_", "", year)) %>%
    mutate(year = as.numeric(year))

ro_merge <- net_migr_nuts3_ro_long %>% 
  left_join(ro_hospital_beds_long, by = c("NUTS3" = "NUTS3", "year" = "year"))
