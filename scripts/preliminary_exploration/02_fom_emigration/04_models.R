
# Chow test ------------------------------------------------------------------
# https://en.wikipedia.org/wiki/Chow_test

# Prepare Data
migr_romania <- net_int_migration %>% 
  dplyr::filter(Country == "Romania") %>% 
  dplyr::filter(Year >= 1997 & Year <= 2017)

migr_poland <- net_int_migration %>% 
  dplyr::filter(Country == "Poland") %>% 
  dplyr::filter(Year >= 1994 & Year <= 2014)

migr_croatia <- net_int_migration %>% 
  dplyr::filter(Country == "Croatia") %>% 
  dplyr::filter(Year >= 2003 & Year <= 2023) %>% 
  drop_na(Emigration)

# Perform Chow test
sctest(migr_romania$Emigration ~ migr_romania$Year, type = "Chow", point = 12)
#0.002231 < 0.05

sctest(migr_poland$Emigration ~ migr_poland$Year, type = "Chow", point = 12)
#0.04159 < 0.05

sctest(migr_croatia$Emigration ~ migr_croatia$Year, type = "Chow", point = 4)
#0.04393 < 0.05


# Pre-whitening ------------------------------------------------------------------
library(forecast)

# Fit ARIMA model to data
fit <- auto.arima(migr_romania$Emigration)

# Obtain residuals, which should be white noise if model fits well
residuals <- residuals(fit)

# Perform t-test on residuals for two time periods
residuals_1994_2004 <- residuals[migr_romania$Year >= 1997 & migr_romania$Year <= 2007]
residuals_2005_2015 <- residuals[migr_romania$Year >= 2008 & migr_romania$Year <= 2017]
t_result <- t.test(residuals_1994_2004, residuals_2005_2015)
print(t_result)
