
# EDA --------------------------

## Schools ----------------------------------

ggplot(pl_schools, aes(x = year, y = ratio_schools, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(hr_schools, aes(x = year, y = schools, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(hr_schools_pop, aes(x = year, y = population, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(hr_schools, aes(x = year, y = ratio_schools, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(ro_schools, aes(x = year, y = schools, line = nuts2016)) +
  geom_line() +
  theme_minimal()

ggplot(ro_schools_pop, aes(x = year, y = population, line = nuts2016)) +
  geom_line() +
  theme_minimal()

ggplot(ro_schools, aes(x = year, y = ratio_schools, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(pl_schools, aes(x = ratio_schools)) +
  geom_histogram(binwidth = 5) +
  theme_minimal()

ggplot(pl_schools, aes(x = ratio_schools)) +
  geom_boxplot() +
  theme_minimal()


## Hospitals -----------------------------------

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


## Third Places -----------------------------------

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


## Remittances -----------------------------------

ggplot(pl_remittances, aes(x = year, y = remittances)) +
  geom_line() + theme_minimal()


## GDP -----------------------------------

ggplot(pl_gdp, aes(x = year, y = gdp, line = NUTS_ID)) +
  geom_line() + theme_minimal()
