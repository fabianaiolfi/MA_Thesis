
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