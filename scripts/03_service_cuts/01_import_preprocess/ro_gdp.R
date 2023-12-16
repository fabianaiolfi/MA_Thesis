
# GPD at NUTS3 --------------------------------

# Euro per inhabitant
# Source: https://ec.europa.eu/eurostat/databrowser/view/nama_10r_3gdp__custom_9030433/default/table?lang=en (retrieved 16 December 2023)
raw_csv <- read_csv(here("data", "03_service_cuts", "ro", "nama_10r_3gdp__custom_9030433_linear.csv"))

ro_gdp <- raw_csv %>% 
  select(geo, TIME_PERIOD, OBS_VALUE) %>% 
  rename(NUTS_ID = geo,
         year = TIME_PERIOD,
         gdp = OBS_VALUE)


## Export ------------------------------

save(ro_gdp, file = here("data", "03_service_cuts", "ro", "ro_gdp.Rda"))
