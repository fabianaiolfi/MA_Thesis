
# Modelling -------------------------------------------------------------------

## Bulgaria -------------------------------------------------------------------

# Remove outliers
bg_merge <- bg_merge %>% 
  dplyr::filter(OBS_VALUE < 6000) %>%
  dplyr::filter(year >= 2011 & year < 2020)

# Ordinary Least Squares: Naive Approach
ols <- lm(OBS_VALUE ~ net_migration, bg_merge)
summary(ols)

# Lagged Panel Data
bg_third_places_emigration_pdata <- pdata.frame(bg_merge, index = c("NUTS2", "year"))
bg_third_places_emigration_pdata$net_migration_lag <- lag(bg_third_places_emigration_pdata$net_migration, 2)

plm_model <- plm(OBS_VALUE ~ net_migration_lag,
                 data = bg_third_places_emigration_pdata,
                 model = "within")
summary(plm_model)

### Plots -------------------------------------------------------------------

# OLS
plot(bg_merge$net_migration, bg_merge$OBS_VALUE)

# Lagged Panel Data
df_plot <- as.data.frame(bg_third_places_emigration_pdata)
plot(as.numeric(df_plot$net_migration_lag), as.numeric(df_plot$OBS_VALUE))


## Czech Republic -------------------------------------------------------------------

# Remove outliers
cz_merge <- cz_merge %>% 
  dplyr::filter(NUTS2 != "CZZZ") %>%
  #dplyr::filter(year < 2020)
  dplyr::filter(year > 2009 & year < 2020)

# Ordinary Least Squares: Naive Approach
ols <- lm(OBS_VALUE ~ net_migration, cz_merge)
summary(ols)

# Lagged Panel Data
cz_third_places_emigration_pdata <- pdata.frame(cz_merge, index = c("NUTS2", "year"))
cz_third_places_emigration_pdata$net_migration_lag <- lag(cz_third_places_emigration_pdata$net_migration, 2)

plm_model <- plm(OBS_VALUE ~ net_migration_lag,
                 data = cz_third_places_emigration_pdata,
                 model = "within")
summary(plm_model)
stargazer(plm_model)
