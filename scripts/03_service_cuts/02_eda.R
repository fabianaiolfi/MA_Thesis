
# EDA --------------------------

## Schools ----------------------------------

ggplot(pl_school_pop, aes(x = year, y = population, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(pl_schools, aes(x = year, y = ratio, line = NUTS_ID)) +
  geom_line() +
  theme_minimal()

ggplot(pl_school_pop, aes(x = year, y = population, line = NUTS_ID)) +
  geom_line() +
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


## Third Places -----------------------------------

ggplot(pl_restaurants, aes(x = year, y = restaurants, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_bars, aes(x = year, y = bars, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_third_places, aes(x = year, y = bars, line = NUTS_ID)) +
  geom_line() + theme_minimal()

ggplot(pl_third_places, aes(x = year, y = ratio_third_places, line = NUTS_ID)) +
  geom_line() + theme_minimal()
