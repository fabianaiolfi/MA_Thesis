
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
  left_join(select(average_emigration, -regionname), by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(crude_emigration)

summary(lm(vote_change ~ average_emigration, anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = average_emigration, y = vote_change)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()
