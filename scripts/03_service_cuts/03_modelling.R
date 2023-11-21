
# Polish Election Years -------------------------------------

election_years <- ned_v_dem_cee %>% 
  dplyr::filter(str_detect(nuts2016, "^PL")) %>% 
  distinct(year) %>% 
  arrange(year)

election_years <- election_years$year
election_years <- c(1997, 2001, election_years) # Previous elections


# Modelling ----------------------------------

# Calculate the year after each election
post_election_years <- election_years + 1

pl_schools <- pl_schools %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  mutate(is_post_election_year = year %in% post_election_years) %>%
  mutate(baseline_ratio = ifelse(is_post_election_year, ratio, NA_real_)) %>%
  tidyr::fill(baseline_ratio, .direction = "down") %>%
  mutate(adjusted_ratio = 100 * ratio / baseline_ratio) %>%
  # Create a cycle identifier based on election years
  mutate(cycle = cumsum(year %in% post_election_years)) %>%
  group_by(NUTS_ID, cycle) %>%
  mutate(average_adjusted_ratio = mean(adjusted_ratio, na.rm = TRUE)) %>%
  ungroup() %>%
  select(-baseline_ratio, -is_post_election_year, -cycle) %>% 
  mutate(diff = average_adjusted_ratio - 100) %>% 
  select(NUTS_ID, year, diff) %>% 
  dplyr::filter(year %in% election_years)


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
  dplyr::filter(lrgen_fct == "Right") %>% # Build model with lrgen_fct
  #dplyr::filter(galtan_fct == "6_8") %>% # Build model with galtan_fct
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  #dplyr::filter(average_emigration < 2) %>% # Testing removing outliers
  drop_na(crude_emigration)

anti_incumbent_vote <- anti_incumbent_vote %>% 
  left_join(pl_schools, by = c("year" = "year", "nuts2016" = "NUTS_ID"))

summary(lm(vote_change ~ diff, anti_incumbent_vote))
summary(lm(vote_change ~ diff + average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = diff, y = vote_change, color = lrgen_fct)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()















## taken from 02_external_emigration > 03_modelling.R

# summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))
# summary(lm(vote_change ~ average_emigration + average_schools_diff, anti_incumbent_vote))

# average_emigration <- pl %>%
#   arrange(NUTS_ID, year) %>%
#   group_by(NUTS_ID) %>%
#   # Take rolling average of past 2 years into account, ignore current year
#   mutate(average_emigration = slider::slide_dbl(crude_emigration, mean, .before = 2, .after = -1, .complete = T)) %>%
#   ungroup() %>%
#   mutate(average_schools_diff = slider::slide_dbl(schools_diff, mean, .before = 8, .after = -1, .complete = T)) %>%
#   ungroup()















