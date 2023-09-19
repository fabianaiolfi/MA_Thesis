
# Preprocessing -------------------------------------------------------------

## Croatia

population_croatia <- population %>% 
  select(geo, TIME_PERIOD, age, OBS_VALUE) %>% 
  dplyr::filter(grepl("HR", geo)) %>% 
  dplyr::filter(age != "TOTAL") %>% 
  dplyr::filter(geo != "HR") %>% 
  dplyr::filter(geo != "HR0")


unique(population_croatia$age)
