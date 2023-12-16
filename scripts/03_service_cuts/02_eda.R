
# EDA --------------------------

## Population ----------------------------------

# Romania
nuts3_population %>% 
  dplyr::filter(str_detect(NUTS_ID, "^RO")) %>% 
  dplyr::filter(nchar(NUTS_ID) == 5) %>% # Only NUTS3
  # dplyr::filter(population > 10000000) %>% # Only entire population
  ggplot(aes(x = year, y = population, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ro_population %>% 
  # dplyr::filter(population < 1000000) %>% # Only entire population
  ggplot(aes(x = year, y = population, line = NUTS_ID)) +
  geom_line() +
  facet_wrap(~ NUTS_ID, scales = "free_y") +
  theme_minimal()

## Schools ----------------------------------

# Poland
ggplot(pl_schools, aes(x = year, y = ratio_schools, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(pl_schools, aes(x = ratio_schools)) +
  geom_histogram(binwidth = 5) +
  theme_minimal()

ggplot(pl_schools, aes(x = ratio_schools)) +
  geom_boxplot() +
  theme_minimal()

# Croatia
ggplot(hr_schools, aes(x = year, y = schools, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(hr_schools_pop, aes(x = year, y = population, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(hr_schools, aes(x = year, y = ratio_schools, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

# Romania
ggplot(ro_schools, aes(x = year, y = schools, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(ro_schools_pop, aes(x = year, y = population, line = nuts2016)) +
  geom_line() +
  theme_minimal()

ggplot(ro_schools, aes(x = year, y = ratio_schools, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()


## Hospitals -----------------------------------

# Poland
ggplot(pl_hospitals, aes(x = year, y = hospitals, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_hospitals, aes(x = year, y = ratio_hospitals_all_population, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_hospitals, aes(x = year, y = ratio_hospitals_population_over_70, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_hospitals, aes(x = year, y = ratio_hospital_beds_all_population, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_hospitals, aes(x = year, y = ratio_hospital_beds_population_over_70, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_hospitals, aes(x = ratio_hospitals_all_population)) +
  geom_histogram(binwidth = 500) +
  theme_minimal()

ggplot(pl_hospitals, aes(x = ratio_hospitals_all_population)) +
  geom_boxplot() +
  theme_minimal()

# Romania
ggplot(ro_hospitals, aes(x = year, y = hospitals, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(ro_hospitals, aes(x = year, y = ratio_hospitals, line = NUTS_ID)) +
  geom_line() + theme_minimal()


## Third Places -----------------------------------

# Poland
ggplot(pl_restaurants, aes(x = year, y = restaurants, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_bars, aes(x = year, y = bars, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_third_places, aes(x = year, y = bars, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_third_places, aes(x = year, y = ratio_third_places, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_third_places, aes(x = year, y = ratio_bars, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_third_places, aes(x = ratio_third_places)) +
  geom_histogram() +
  theme_minimal()

ggplot(pl_third_places, aes(x = ratio_third_places)) +
  geom_boxplot() +
  theme_minimal()

# Romania
ggplot(ro_third_places, aes(x = year, y = third_places, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(ro_third_places, aes(x = year, y = ratio_third_places, line = NUTS_ID)) +
  geom_line() + theme_minimal()



## Remittances -----------------------------------

ggplot(pl_remittances, aes(x = year, y = remittances)) +
  geom_line() + theme_minimal()

ggplot(ro_remittances, aes(x = year, y = remittances)) +
  geom_line() + theme_minimal()


## GDP -----------------------------------

ggplot(pl_gdp, aes(x = year, y = gdp, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(ro_gdp, aes(x = year, y = gdp, line = NUTS_ID)) +
  geom_line() + theme_minimal()
