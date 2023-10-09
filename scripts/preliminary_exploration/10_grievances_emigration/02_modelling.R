
# Modelling -------------------------------------------------------------------

ess_eda <- ess_eda %>% 
  dplyr::filter(year == 2013) %>% 
  left_join(net_migr_nuts3_2008_2012, by = c("region" = "nuts"))


plot(ess_eda$avg_migration, ess_eda$weighted_avg)

summary(lm(weighted_avg ~ avg_migration, data=ess_eda))


# to do
# - missing nuts values
# - further ess rounds