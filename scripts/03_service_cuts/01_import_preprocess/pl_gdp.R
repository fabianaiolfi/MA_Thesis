
# GPD at NUTS2 --------------------------------

# Source: https://ec.europa.eu/eurostat/databrowser/view/nama_10r_2gdp__custom_8714120/default/table?lang=en (retrieved 27 November 2023)
raw_csv <- read_csv(here("data", "03_service_cuts", "pl", "nama_10r_2gdp__custom_8714120_linear.csv"))

pl_gdp <- raw_csv %>% 
  select(geo, TIME_PERIOD, OBS_VALUE) %>% 
  rename(NUTS_ID = geo,
         year = TIME_PERIOD,
         gdp = OBS_VALUE)


## Export ------------------------------

save(pl_gdp, file = here("data", "03_service_cuts", "pl", "pl_gdp.Rda"))
