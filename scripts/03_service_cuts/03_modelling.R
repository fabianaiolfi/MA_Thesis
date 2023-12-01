
# Preprocessing ----------------------------------

# Experimental: How has the ratio changed compared to the last election?
# 1. Use ratio value after an election as a baseline
# 2. Calculate change between two elections

# Calculate the year after each election
# post_pl_election_years <- pl_election_years + 1
# 
# pl_schools <- pl_schools %>%
#   arrange(NUTS_ID, year) %>%
#   group_by(NUTS_ID) %>%
#   mutate(is_post_election_year = year %in% post_pl_election_years) %>%
#   mutate(baseline_ratio = ifelse(is_post_election_year, ratio, NA_real_)) %>%
#   tidyr::fill(baseline_ratio, .direction = "down") %>%
#   mutate(adjusted_ratio = 100 * ratio / baseline_ratio) %>%
#   # Create a cycle identifier based on election years
#   mutate(cycle = cumsum(year %in% post_pl_election_years)) %>%
#   group_by(NUTS_ID, cycle) %>%
#   mutate(average_adjusted_ratio = mean(adjusted_ratio, na.rm = TRUE)) %>%
#   ungroup() %>%
#   select(-baseline_ratio, -is_post_election_year, -cycle) %>% 
#   mutate(diff = average_adjusted_ratio - 100) %>% 
#   select(NUTS_ID, year, diff) %>% 
#   dplyr::filter(year %in% pl_election_years)

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- pl %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 2 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(emigration_yearly_per_1000, mean, .before = 2, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(emigration_yearly_per_1000)

anti_incumbent_vote <- anti_incumbent_vote %>% 
  left_join(select(pl_schools, -population), by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>%
  left_join(select(pl_hospitals, -population), by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  left_join(select(pl_third_places, -population), by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  left_join(pl_remittances, by = "year") %>% 
  left_join(pl_gdp, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  dplyr::filter(nuts2016 != "PL91") # Remove potentially problematic NUTS2 region (Warszawski stołeczny)

# Create Tertile Factors
test <- anti_incumbent_vote %>%
  mutate(
    ratio_schools_tertiles = ntile(ratio_schools, 4),
    ratio_schools_tertiles = factor(ratio_schools_tertiles, levels = c(1,2,3,4), labels = c("low", "mid", "high", "very high")),
    
    ratio_hospitals_tertiles = ntile(ratio_hospitals_all_population, 4),
    ratio_hospitals_tertiles = factor(ratio_hospitals_tertiles, levels = c(1,2,3,4), labels = c("low", "mid", "high", "very high")),
    
    ratio_third_places_tertiles = ntile(ratio_third_places, 4),
    ratio_third_places_tertiles = factor(ratio_third_places_tertiles, levels = c(1,2,3,4), labels = c("low", "mid", "high", "very high")),
    
    average_emigration_tertiles = ntile(average_emigration, 4),
    average_emigration_tertiles = factor(average_emigration_tertiles, levels = c(1,2,3,4), labels = c("low", "mid", "high", "very high"))
  )



# Modelling ----------------------------------

summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population, anti_incumbent_vote))
summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population + emigration_election_year_per_1000, anti_incumbent_vote))
summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population + ratio_third_places + average_emigration + lrgen_fct, anti_incumbent_vote))
summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population + average_emigration, anti_incumbent_vote)) # best model so far

summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population + ratio_third_places, anti_incumbent_vote))
summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population + ratio_third_places + average_emigration, anti_incumbent_vote)) # thesis model
summary(lm(vote_change ~ ratio_schools + ratio_third_places + average_emigration, anti_incumbent_vote))
summary(lm(vote_change ~ ratio_schools + ratio_third_places + ratio_hospital_beds_population_over_70 + average_emigration, anti_incumbent_vote))
summary(lm(vote_change ~ ratio_schools + ratio_third_places + ratio_hospital_beds_all_population + average_emigration, anti_incumbent_vote)) # also good
summary(lm(vote_change ~ ratio_schools + ratio_third_places + ratio_hospital_beds_all_population, anti_incumbent_vote)) # 
summary(lm(vote_change ~ ratio_schools + ratio_third_places + ratio_hospitals_all_population + average_emigration, anti_incumbent_vote))
summary(lm(vote_change ~ ratio_schools + ratio_third_places + ratio_hospitals_population_over_70 + average_emigration, anti_incumbent_vote))

summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population + ratio_bars + average_emigration, anti_incumbent_vote)) # nice
summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population + ratio_bars + emigration_election_year_per_1000, anti_incumbent_vote)) # nice
summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population + ratio_bars + average_emigration, anti_incumbent_vote)) #  
summary(lm(vote_change ~ ratio_schools + ratio_hospital_beds_population_over_70 + ratio_bars + emigration_election_year_per_1000, anti_incumbent_vote)) #  ???
summary(lm(vote_change ~ ratio_schools + ratio_hospital_beds_population_over_70 + ratio_bars + average_emigration, anti_incumbent_vote)) #  
summary(lm(vote_change ~ ratio_schools + ratio_hospital_beds_all_population + ratio_bars + emigration_election_year_per_1000, anti_incumbent_vote)) # nice

summary(lm(vote_change ~ ratio_schools + ratio_hospitals_all_population + ratio_bars + emigration_election_year_per_1000, anti_incumbent_vote)) 

summary(lm(vote_change ~
             ratio_schools + 
             ratio_hospitals_all_population +
             ratio_third_places +
             emigration_election_year_per_1000 +
             remittances,
           anti_incumbent_vote)) # v good

summary(lm(vote_change ~
             ratio_schools +
             ratio_hospitals_all_population +
             ratio_third_places +
             emigration_election_year_per_1000 +
             remittances +
             gdp,
           anti_incumbent_vote)) # thesis model


colnames(anti_incumbent_vote)

ggplot(anti_incumbent_vote, aes(x = ratio_hospitals_all_population, y = vote_change))+#, color = lrgen_fct)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


# Fixed Effects Models ----------------------------------------------------


feols_model <- feols(vote_change ~
                       ratio_schools +
                       ratio_hospitals_all_population +
                       ratio_third_places +
                       emigration_election_year_per_1000 +
                       remittances +
                       gdp | 
                       nuts2016 + year,
                     data = anti_incumbent_vote)

summary(feols_model)

feols_model <- feols(vote_change ~
                       ratio_schools_tertiles +
                       ratio_hospitals_tertiles +
                       ratio_third_places_tertiles +
                       #emigration_election_year_per_1000 +
                       #average_emigration +
                       #emigration_yearly_per_1000 +
                       average_emigration_tertiles +
                       remittances +
                       gdp | 
                       nuts2016 + year,
                     data = test)

summary(feols_model)


