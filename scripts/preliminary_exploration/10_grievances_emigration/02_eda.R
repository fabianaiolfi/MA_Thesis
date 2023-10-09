
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

## Plots -------------------------------------------------------------------

plot(ess_eda_2013$avg_migration, ess_eda_2013$weighted_avg)
plot(ess_eda_2017$avg_migration, ess_eda_2017$weighted_avg)
plot(ess_eda_2019$avg_migration, ess_eda_2019$weighted_avg)
plot(ess_eda_2021$avg_migration, ess_eda_2021$weighted_avg)

summary(lm(weighted_avg ~ avg_migration, data = ess_eda_2013))
summary(lm(weighted_avg ~ avg_migration, data = ess_eda_2017))
summary(lm(weighted_avg ~ avg_migration, data = ess_eda_2019))
summary(lm(weighted_avg ~ avg_migration, data = ess_eda_2021))
