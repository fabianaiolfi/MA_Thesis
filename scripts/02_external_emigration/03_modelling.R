
# Modelling -------------------------------------------------------------

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
  left_join(select(average_emigration, -regionname), by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration)

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
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

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
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

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
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

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
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

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
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

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Poland -------------------------------------------------------------

# ned_v_dem_cee only contains NUTS2 for Poland
# Adjust accordingly: Average NUTS3 crude emigration into NUTS2
average_emigration <- pl %>%
  mutate(NUTS_ID = str_sub(NUTS_ID, 1, -2)) %>% 
  group_by(NUTS_ID, year) %>% 
  summarise(crude_emigration = mean(crude_emigration, na.rm = T)) %>% 
  mutate(crude_emigration = gsub("NaN", NA, crude_emigration)) %>% 
  mutate(crude_emigration = as.numeric(crude_emigration))

# NUTS3 electoral data could be retrieved from https://wybory.gov.pl/sejmsenat2023/en/sejm/wynik/pl,
# but only with a massive effort

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- average_emigration %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  # dplyr::filter(partyfacts_id == 1565) %>% # Build model with a single party
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration)

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
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

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
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

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Slovenia -------------------------------------------------------------

# ned_v_dem_cee only contains NUTS1 for Slovenia
# NUTS3 level results could be calculated using these links:
# https://www.dvk-rs.si/arhivi/dz2018/#/rezultati and (e.g.) https://en.wikipedia.org/wiki/Mura_Statistical_Region

average_emigration <- si %>%
  mutate(NUTS_ID = "SI0") %>% 
  group_by(NUTS_ID, year) %>% 
  summarise(crude_emigration = mean(crude_emigration, na.rm = T)) %>% 
  mutate(crude_emigration = gsub("NaN", NA, crude_emigration)) %>% 
  mutate(crude_emigration = as.numeric(crude_emigration))

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- average_emigration %>%
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

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change, color = as.factor(partyfacts_id))) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()
