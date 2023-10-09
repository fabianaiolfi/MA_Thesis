
# Modelling -------------------------------------------------------------------

# Ordinary Least Squares: Naive Approach
ols <- lm(schools ~ net_migration, hr_schools_emigration)
summary(ols)

# Lagged Panel Data
hr_schools_emigration_pdata <- pdata.frame(hr_schools_emigration, index = c("NUTS", "year"))
hr_schools_emigration_pdata$net_migration_lag <- lag(hr_schools_emigration_pdata$net_migration, 8)

plm_model <- plm(schools ~ net_migration_lag,
                 data = hr_schools_emigration_pdata,
                 model = "within")
summary(plm_model)


# Plots -------------------------------------------------------------------

# OLS
plot(hr_schools_emigration$net_migration, hr_schools_emigration$schools)

# Lagged Panel Data
df_plot <- as.data.frame(hr_schools_emigration_pdata)
plot(as.numeric(df_plot$net_migration_lag), as.numeric(df_plot$schools))

ggplot(df_plot, aes(net_migration_lag, schools)) +            
  geom_point() +
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") +
  ylab("Number of Schools in NUTS3 Region") +
  xlab("Net Migration in NUTS3 Region (Lag: 8 years)") +
  theme_minimal()
