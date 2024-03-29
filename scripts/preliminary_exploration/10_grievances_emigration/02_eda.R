
# Exploratory Data Analysis -------------------------------------------------------------------
ess_eda <- ess_subset %>%
  group_by(essround, region) %>%
  summarise(weighted_avg = sum(happy * anweight) / sum(anweight)) %>% 
  mutate(year = case_when(essround == 6 ~ 2013,
                          essround == 8 ~ 2017,
                          essround == 9 ~ 2019,
                          essround == 10 ~ 2021))

# Modelling -------------------------------------------------------------------

## Set Models -------------------------------------------------------------------

ess_eda_2013 <- ess_eda %>% 
  dplyr::filter(year == 2013) %>% 
  left_join(net_migr_nuts3_2012, by = c("region" = "nuts"))

ess_eda_2017 <- ess_eda %>% 
  dplyr::filter(year == 2017) %>% 
  left_join(net_migr_nuts3_2016, by = c("region" = "nuts"))

ess_eda_2019 <- ess_eda %>% 
  dplyr::filter(year == 2019) %>% 
  left_join(net_migr_nuts3_2018, by = c("region" = "nuts"))

ess_eda_2021 <- ess_eda %>% 
  dplyr::filter(year == 2021) %>% 
  left_join(net_migr_nuts3_2019, by = c("region" = "nuts")) %>% 
  dplyr::filter(avg_migration < 30) # Remove outlier


## Models -------------------------------------------------------------------

lm_2013 <- lm(weighted_avg ~ avg_migration, data = ess_eda_2013)
stargazer(lm_2013)

lm_2017 <- lm(weighted_avg ~ avg_migration, data = ess_eda_2017)
stargazer(lm_2017)

lm_2019 <- lm(weighted_avg ~ avg_migration, data = ess_eda_2019)
stargazer(lm_2019)

lm_2021 <- lm(weighted_avg ~ avg_migration, data = ess_eda_2021)
stargazer(lm_2021)
