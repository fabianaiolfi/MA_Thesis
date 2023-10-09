
# Modelling -------------------------------------------------------------------

## Romania -------------------------------------------------------------------

# Remove outliers
ro_merge <- ro_merge %>% 
  dplyr::filter(nr_of_beds < 15000) %>% 
  dplyr::filter(year > 2010 & year < 2020)

# Ordinary Least Squares: Naive Approach
ols <- lm(nr_of_beds ~ net_migration, ro_merge)
summary(ols)

# Lagged Panel Data
ro_hospital_beds_emigration_pdata <- pdata.frame(ro_merge, index = c("NUTS3", "year"))
ro_hospital_beds_emigration_pdata$net_migration_lag <- lag(ro_hospital_beds_emigration_pdata$net_migration, 1)

plm_model <- plm(nr_of_beds ~ net_migration_lag,
                 data = ro_hospital_beds_emigration_pdata,
                 model = "within")
summary(plm_model)


# Plots -------------------------------------------------------------------

# OLS
plot(ro_merge$net_migration, ro_merge$nr_of_beds)

# Lagged Panel Data
df_plot <- as.data.frame(ro_hospital_beds_emigration_pdata)
plot(as.numeric(df_plot$net_migration_lag), as.numeric(df_plot$nr_of_beds))
