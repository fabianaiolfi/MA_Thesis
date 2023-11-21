
# Modelling -------------------------------------------------------------

## All countries --------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- cee_crude_emigration %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1431) %>% # Build model with a single party
  # dplyr::filter(lrgen_fct == "Right") %>% # Build model with lrgen_fct
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration) %>% 
  drop_na(lrgen_fct) %>% 
  mutate(country = str_sub(nuts2016, end = 2))

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = galtan_fct)) + # lrgen_fct
  geom_point() +
  geom_smooth(method = "lm", se = F, na.rm = T) +
  # geom_smooth(method = "loess", color = "green", se = F) +
  facet_wrap(~ country, scales = "free") +
  theme_minimal()


## Bulgaria --------------------------------------------

bg_election_years <- ned_v_dem_cee %>%
  dplyr::filter(str_detect(nuts2016, "^BG")) %>%
  select(year) %>%
  distinct(year) %>%
  arrange(year)

bg_election_years <- bg_election_years$year

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- bg %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  #dplyr::filter(partyfacts_id == 760) %>% # Build model with a single party
  # dplyr::filter(lrgen_fct == "Centre") %>% # Build model with lrgen_fct
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration)

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = lrgen_fct)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Croatia --------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- hr %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1431) %>% # Build model with a single party
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration)

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(unique_party_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Estonia -------------------------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- ee %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1431) %>% # Build model with a single party
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration)

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(unique_party_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Hungary -------------------------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- hu %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1431) %>% # Build model with a single party
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration)

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(unique_party_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Latvia -------------------------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- lv %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1431) %>% # Build model with a single party
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration) 

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(unique_party_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Lithuania -------------------------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- lt %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1431) %>% # Build model with a single party
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration) 

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(unique_party_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Poland -------------------------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- pl %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1565) %>% # Build model with a single party
  # dplyr::filter(lrgen_fct == "Centre Right") %>% # Build model with lrgen_fct
  #dplyr::filter(galtan_fct == "6_8") %>% # Build model with galtan_fct
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  #dplyr::filter(average_emigration < 2) %>% # Testing removing outliers
  drop_na(crude_emigration)

summary(lm(vote_change ~ average_emigration + lrgen_fct, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = lrgen_fct)) + # lrgen_fct # galtan_fct
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Romania -------------------------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- ro %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1431) %>% # Build model with a single party
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration) 

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(unique_party_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Slovakia -------------------------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- sk %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1431) %>% # Build model with a single party
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration) 

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(unique_party_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Slovenia -------------------------------------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- si %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1431) %>% # Build model with a single party
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration) # All rows are dropped here because ned_v_dem_cee only contains NUTS1

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(unique_party_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()
