

# Import -------------------------------------------------------------

ess <- read_dta(here("data", "ESS-Data-Wizard-subset-2023-10-09.dta"))


# Preprocessing
ess_subset <- ess %>% 
  select(essround, anweight, region, happy) %>% 
  drop_na()

# Exploratory Data Analysis
ess_eda <- ess_subset %>%
  group_by(essround, region) %>%
  summarise(weighted_avg = sum(happy * anweight) / sum(anweight)) %>% 
  mutate(year = case_when(essround == 6 ~ 2013,
                          essround == 8 ~ 2017,
                          essround == 9 ~ 2019,
                          essround == 10 ~ 2021))


# Crude rate of net migration plus statistical adjustment [CNMIGRATRT]
# https://ec.europa.eu/eurostat/databrowser/view/DEMO_R_GIND3__custom_7029377/default/table?lang=en
# https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm
# Crude rate of net migration including statistical adjustment is the ratio of the net migration including statistical adjustment during the year to the average population in that year. The value is expressed per 1000 inhabitants. The crude rate of net migration is equal to the difference between the crude rate of population change and the crude rate of natural change (that is, net migration is considered as the part of population change not attributable to births and deaths). It is calculated in this way because immigration or emigration flows are either not available or the figures are not reliable.
net_migr_nuts3 <- read_csv(here("data", "demo_r_gind3_spreadsheet_sheet_2.csv"),
                           na = ":",
                           show_col_types = FALSE)


net_migr_nuts3_2008_2012 <- net_migr_nuts3 %>% 
  rename(nuts = `GEO (Codes)`,
         nuts_name = `GEO (Labels)`) %>% 
  select(nuts, nuts_name, `2008`, `2009`, `2010`, `2011`, `2012`) %>% 
  mutate(avg_migration = rowMeans(select(., `2008`, `2009`, `2010`, `2011`, `2012`))) %>% 
  select(nuts, nuts_name, avg_migration)






# 
# # Third Places (Eurostat: SBS_R_NUTS06_R2 -> Food and beverage service activities)
# third_places <- read_csv(here("data", "sbs_r_nuts06_r2__custom_7738572_linear.csv"))
# 
# 
# # EDA -------------------------------------------------------------
# 
# third_places <- third_places %>% 
#   select(geo, TIME_PERIOD, OBS_VALUE) %>% 
#   mutate(NUTS_level = case_when(str_length(geo) == 2 ~ "NUTS0",
#                                 str_length(geo) == 3 ~ "NUTS1",
#                                 str_length(geo) == 4 ~ "NUTS2"))
# 
# third_places_nat <- third_places %>% 
#   dplyr::filter(NUTS_level == "NUTS2") %>% 
#   dplyr::filter(str_detect(geo, "CZ"))
# 
# ggplot(third_places_nat) +
#   geom_line(aes(x = TIME_PERIOD, y = OBS_VALUE)) +
#   facet_wrap(~ geo, scales = "free_y") +
#   theme_minimal()
# 
# 
# # Data Preprocessing -------------------------------------------------------------
# 
# ## Bulgaria -------------------------------------------------------------
# 
# bg_third_places <- third_places %>% 
#   dplyr::filter(NUTS_level == "NUTS2") %>% 
#   select(-NUTS_level) %>% 
#   dplyr::filter(str_detect(geo, "BG"))
# 
# net_migr_nuts2_bg_long <- net_migr_nuts3 %>%
#   dplyr::filter(str_detect(`GEO (Codes)`, "BG")) %>%
#   dplyr::filter(str_length(`GEO (Codes)`) == 4) %>%
#   rename(NUTS2 = `GEO (Codes)`)
# 
# net_migr_nuts2_bg_long <- net_migr_nuts2_bg_long %>%
#   group_by(NUTS2) %>%
#   summarise(across(`2000`:`2022`, ~coalesce(.x[1], .x[2], .x), .names = "year_{.col}")) %>%
#   distinct(NUTS2, .keep_all = T) %>%
#   pivot_longer(
#     cols = year_2000:year_2022,      # The columns to reshape
#     names_to = "year",         # The name of the new column for the year
#     values_to = "net_migration"        # The name of the new column for the values
#   ) %>%
#   mutate(year = gsub("year_", "", year)) %>%
#   mutate(year = as.numeric(year))
# 
# bg_merge <- net_migr_nuts2_bg_long %>%
#   left_join(bg_third_places, by = c("NUTS2" = "geo", "year" = "TIME_PERIOD"))
# 
# 
# ## Czech Republic -------------------------------------------------------------
# 
# cz_third_places <- third_places %>% 
#   dplyr::filter(NUTS_level == "NUTS2") %>% 
#   select(-NUTS_level) %>% 
#   dplyr::filter(str_detect(geo, "CZ"))
# 
# net_migr_nuts2_cz_long <- net_migr_nuts3 %>%
#   dplyr::filter(str_detect(`GEO (Codes)`, "CZ")) %>%
#   dplyr::filter(str_length(`GEO (Codes)`) == 4) %>%
#   rename(NUTS2 = `GEO (Codes)`)
# 
# net_migr_nuts2_cz_long <- net_migr_nuts2_cz_long %>%
#   group_by(NUTS2) %>%
#   summarise(across(`2000`:`2022`, ~coalesce(.x[1], .x[2], .x), .names = "year_{.col}")) %>%
#   distinct(NUTS2, .keep_all = T) %>%
#   pivot_longer(
#     cols = year_2000:year_2022,      # The columns to reshape
#     names_to = "year",         # The name of the new column for the year
#     values_to = "net_migration"        # The name of the new column for the values
#   ) %>%
#   mutate(year = gsub("year_", "", year)) %>%
#   mutate(year = as.numeric(year))
# 
# cz_merge <- net_migr_nuts2_cz_long %>%
#   left_join(cz_third_places, by = c("NUTS2" = "geo", "year" = "TIME_PERIOD"))
