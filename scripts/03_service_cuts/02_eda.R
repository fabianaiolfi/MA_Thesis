
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


# Is there a correlation between emigration and population?

# summary(lm(population ~ emigration_yearly_per_1000, ro))
# plot(ro$emigration_yearly_per_1000, ro$population)

temp_df <- ro %>%
  left_join(ro_fertility, by = c("NUTS_ID" = "nuts2016", "year" = "year")) %>% 
  left_join(ro_schools_temp, by = c("NUTS_ID", "year")) %>% 
  group_by(NUTS_ID) %>%
  arrange(year) %>%
  mutate(lagged_emigration = dplyr::lag(emigration, 1)) %>% 
  mutate(lagged_emigration_yearly_per_1000 = dplyr::lag(emigration_yearly_per_1000, 6)) %>% 
  mutate(lagged_fertility = dplyr::lag(fertility, 1)) %>% 
  mutate(pop_diff = c(NA, diff(population.x))) %>% 
  mutate(school_pop_diff = c(NA, diff(population.y))) %>% 
  mutate(pop_diff_percent = c(NA, diff(population.x) / head(population.x, -1) * 100)) %>% 
  mutate(school_pop_diff_percent = c(NA, diff(population.y) / head(population.y, -1) * 100)) %>% 
  mutate(lagged_school_pop = dplyr::lag(population.y, 1)) %>% 
  mutate(lagged_school_ratio = dplyr::lag(ratio_schools, 1)) %>% 
  mutate(ratio_diff = c(NA, diff(ratio_schools)))


# plot(temp_df$lagged_emigration, temp_df$pop_diff)

fe_lm <- feols(pop_diff ~
                 lagged_emigration *
                 lagged_fertility |
                 NUTS_ID + year,
               data = temp_df)

fe_lm <- feols(pop_diff ~
                 emigration *
                 fertility |
                 NUTS_ID + year,
               data = temp_df)

fe_lm <- feols(population ~
                 emigration_yearly_per_1000 *
                 fertility |
                 NUTS_ID + year,
               data = temp_df)
fe_lm

summary(lm(pop_diff ~ emigration, temp_df))
summary(lm(pop_diff ~ emigration + fertility, temp_df))
summary(lm(pop_diff ~ emigration * fertility, temp_df))
summary(lm(population ~ lagged_emigration_yearly_per_1000 * lagged_fertility, temp_df))
summary(lm(pop_diff ~ lagged_emigration_yearly_per_1000 * lagged_fertility, temp_df))

fe_lm <- feols(pop_diff_percent ~
                 lagged_emigration_yearly_per_1000 *
                 lagged_fertility |
                 NUTS_ID + year,
               data = temp_df)
fe_lm

# very nice results?
fe_lm <- feols(school_diff_percent ~
                 lagged_emigration_yearly_per_1000 |
                 # lagged_fertility |
                 NUTS_ID + year,
               data = temp_df)

fe_lm <- feols(school_diff ~
                 lagged_emigration_yearly_per_1000 |
                 # lagged_fertility |
                 NUTS_ID + year,
               data = temp_df)

# this is a very nice results, with a lag of 7 years; but result is super volatile if lag is changed
fe_lm <- feols(ratio_diff ~
                 lagged_emigration_yearly_per_1000 |
                 NUTS_ID + year,
               data = temp_df)

fe_lm <- feols(ratio_schools ~
                 emigration_yearly_per_1000 |
                 NUTS_ID + year,
               data = temp_df)
fe_lm

ro_schools_temp <- ro_schools %>% 
  group_by(NUTS_ID) %>%
  arrange(year) %>%
  mutate(school_diff = c(NA, diff(schools))) %>% 
  mutate(school_diff_percent = c(NA, diff(schools) / head(schools, -1) * 100))


#####


temp_df <- ro %>% 
  left_join(ro_fertility, by = c("NUTS_ID" = "nuts2016", "year" = "year")) %>% 
  # dplyr::filter(NUTS_ID == "RO121") %>% 
  mutate(lagged_population = dplyr::lag(population, 3))

plot(temp_df$fertility, temp_df$lagged_population)

summary(lm(lagged_population ~ fertility, temp_df))


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
