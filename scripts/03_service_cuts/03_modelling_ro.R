
# Preprocessing ----------------------------------

# Calculate the average crude_net_migration for each NUTS_ID for every pair of consecutive years
average_emigration <- ro %>%
  arrange(NUTS_ID, year) %>%
  group_by(NUTS_ID) %>%
  # Take rolling average of past 3 years into account, ignore current year
  mutate(average_emigration = slider::slide_dbl(emigration_yearly_per_1000, mean, .before = 3, .after = -1, .complete = T)) %>%
  ungroup()

anti_incumbent_vote <- ned_v_dem_cee %>% 
  dplyr::filter(prev_incumbent == T) %>%
  left_join(average_emigration, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  drop_na(emigration_yearly_per_1000)

ro_schools <- ro_schools %>% dplyr::filter(NUTS_ID != "RO321") # Remove potentially problematic NUTS3 region

anti_incumbent_vote <- anti_incumbent_vote %>% 
  left_join(select(ro_schools, -population), by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>%
  left_join(select(ro_hospitals, -population), by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  left_join(select(ro_third_places, -population), by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  left_join(ro_remittances, by = "year") %>%
  left_join(ro_gdp, by = c("year" = "year", "nuts2016" = "NUTS_ID")) %>% 
  left_join(ro_volatility, by = c("year", "nuts2016"))


# Modelling ----------------------------------

## Plain Vanilla Thesis Model ---------------------------------

summary(lm(vote_change ~
             schools +
             hospitals +
             third_places +
             emigration_yearly_per_1000 +
             #remittances +
             volatility +
             gdp,
           anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = emigration_yearly_per_1000, y = vote_change))+#, color = lrgen_fct)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Fixed Effects Models ----------------------------------------------------

fe_lm_1 <- feols(vote_change ~
                   schools +
                   hospitals +
                   third_places +
                   # emigration_yearly_per_1000 +
                   average_emigration +
                   # remittances +
                   volatility +
                   gdp |
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_2 <- feols(vote_change ~
                   ratio_hospitals +
                   emigration_election_year_per_1000 +
                   # remittances +
                   volatility +
                   gdp | 
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_3 <- feols(vote_change ~
                   ratio_third_places +
                   emigration_election_year_per_1000 +
                   # remittances +
                   volatility +
                   gdp | 
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_4 <- feols(vote_change ~
                   ratio_schools +
                   ratio_hospitals +
                   emigration_election_year_per_1000 +
                   # remittances +
                   volatility +
                   gdp | 
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_5 <- feols(vote_change ~
                   ratio_schools +
                   ratio_third_places +
                   emigration_election_year_per_1000 +
                   # remittances +
                   volatility +
                   gdp | 
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_6 <- feols(vote_change ~
                   ratio_hospitals +
                   ratio_third_places +
                   emigration_election_year_per_1000 +
                   # remittances +
                   volatility +
                   gdp | 
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_7 <- feols(vote_change ~
                   ratio_schools +
                   ratio_hospitals +
                   ratio_third_places +
                   emigration_election_year_per_1000 +
                   # remittances +
                   volatility +
                   gdp | 
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_8 <- feols(vote_change ~
                   average_ratio_schools_election_year +
                   emigration_election_year_per_1000 +
                   gdp |
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_9 <- feols(vote_change ~
                   # average_ratio_schools_election_year +
                   average_ratio_hospitals_election_year +
                   average_ratio_third_places_election_year +
                   emigration_election_year_per_1000 +
                   gdp |
                   nuts2016 + year,
                 data = anti_incumbent_vote)


# Coefficient Plot --------------------------------------------------------

fe_lm_8_summary = summary(fe_lm_8)
coefplot(list(fe_lm_8_summary),
         horiz = T)#, xlim = c(-0.25, 0))


## Truncate Data ----------------------------------------------------

# Truncate Vote Change
cutoff <- 2

anti_incumbent_vote_truncated <- anti_incumbent_vote %>% 
  dplyr::filter(vote_change > cutoff | vote_change < cutoff * -1)

lm_truncated <- feols(vote_change ~
                        ratio_schools +
                        ratio_hospitals +
                        ratio_third_places +
                        emigration_election_year_per_1000 +
                        # remittances +
                        volatility +
                        gdp | 
                        nuts2016 + year,
                      data = anti_incumbent_vote_truncated)

summary(lm_truncated)

modelplot(lm_truncated,
          coef_map = c(gdp = "GDP",
                       emigration_election_year_per_1000 = "Emigration Rate between Election Years per 1000 People",
                       ratio_third_places = "People per Third Places",
                       ratio_hospitals_all_population = "People per Hospital",
                       ratio_schools = "Children per School"))


# Truncate Vote Share
anti_incumbent_vote_truncated <- anti_incumbent_vote %>% 
  dplyr::filter(vote_share < 25 & vote_share > 5)

lm_truncated <- feols(vote_change ~
                        ratio_schools +
                        ratio_hospitals +
                        ratio_third_places +
                        emigration_election_year_per_1000 +
                        # remittances +
                        volatility +
                        gdp | 
                        nuts2016 + year,
                      data = anti_incumbent_vote_truncated)

summary(lm_truncated)

modelplot(lm_truncated,
          coef_map = c(gdp = "GDP",
                       emigration_election_year_per_1000 = "Emigration Rate between Election Years per 1000 People",
                       ratio_third_places = "People per Third Places",
                       ratio_hospitals_all_population = "People per Hospital",
                       ratio_schools = "Children per School"))


# Truncate Emigration Rate
anti_incumbent_vote_truncated <- anti_incumbent_vote %>% 
  dplyr::filter(emigration_election_year_per_1000 < 4)

lm_truncated <- feols(vote_change ~
                        ratio_schools +
                        ratio_hospitals +
                        ratio_third_places +
                        emigration_election_year_per_1000 +
                        # remittances +
                        volatility +
                        gdp | 
                        nuts2016 + year,
                      data = anti_incumbent_vote_truncated)

summary(lm_truncated)

modelplot(lm_truncated,
          coef_map = c(gdp = "GDP",
                       emigration_election_year_per_1000 = "Emigration Rate between Election Years per 1000 People",
                       ratio_third_places = "People per Third Places",
                       ratio_hospitals_all_population = "People per Hospital",
                       ratio_schools = "Children per School"))
