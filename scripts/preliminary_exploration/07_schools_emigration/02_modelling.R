
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
stargazer(plm_model)
