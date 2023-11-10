
# NUTS3 Population --------------------------------------------------------

nuts3_population <- read_csv(here("data", "demo_r_pjangrp3_linear.csv"))

nuts3_population <- nuts3_population %>% 
  dplyr::filter(sex == "T") %>% 
  dplyr::filter(age == "TOTAL") %>% 
  select(geo, TIME_PERIOD, OBS_VALUE) %>% 
  rename(NUTS_ID = geo,
         year = TIME_PERIOD,
         population = OBS_VALUE)

save(nuts3_population, file = here("data", "02_external_emigration", "nuts3_population.Rda"))
