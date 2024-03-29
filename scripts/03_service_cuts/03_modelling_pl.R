
# Preprocessing ----------------------------------

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
  left_join(pl_volatility, by = c("year", "nuts2016")) %>% 
  dplyr::filter(nuts2016 != "PL91") # Remove potentially problematic NUTS2 region (Warszawski stołeczny)

# Add NUTS Typology
anti_incumbent_vote <- anti_incumbent_vote %>% 
  left_join(nuts3_typologies, by = c("nuts2016" = "NUTS_ID"))


# Modelling ----------------------------------

## Plain Vanilla Thesis Model ---------------------------------

summary(lm(vote_change ~
             ratio_schools +
             ratio_hospitals_all_population +
             ratio_third_places +
             emigration_election_year_per_1000 +
             # remittances +
             volatility +
             gdp,
           anti_incumbent_vote))

ggplot(anti_incumbent_vote, aes(x = emigration_election_year_per_1000, y = vote_change))+#, color = lrgen_fct)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal()


## Fixed Effects Models ----------------------------------------------------

fe_lm_1 <- feols(vote_change ~
                   # ratio_schools +
                   emigration_election_year_per_1000 |
                   # remittances +
                   # volatility +
                   # gdp | 
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_2 <- feols(vote_change ~
                   ratio_hospitals_all_population +
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
                   ratio_hospitals_all_population +
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
                   ratio_hospitals_all_population +
                   ratio_third_places +
                   emigration_election_year_per_1000 +
                   # remittances +
                   volatility +
                   gdp | 
                   nuts2016 + year,
                 data = anti_incumbent_vote)

fe_lm_7 <- feols(vote_change ~
                ratio_schools +
                ratio_hospitals_all_population +
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
                   average_ratio_schools_election_year +
                   average_ratio_hospitals_election_year +
                   average_ratio_third_places_election_year +
                   emigration_election_year_per_1000 +
                   gdp |
                   nuts2016 + year,
                 data = anti_incumbent_vote)


# Coefficient Plot --------------------------------------------------------

fe_lm_7_summary = summary(fe_lm_7)
coefplot(list(fe_lm_7_summary),
         horiz = T)#, xlim = c(-0.25, 0))


## Truncate Data ----------------------------------------------------

# Truncate Vote Change
cutoff <- 2

anti_incumbent_vote_truncated <- anti_incumbent_vote %>% 
  dplyr::filter(vote_change > cutoff | vote_change < cutoff * -1)

lm_truncated <- feols(vote_change ~
                        ratio_schools +
                        ratio_hospitals_all_population +
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
                        ratio_hospitals_all_population +
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
                        ratio_hospitals_all_population +
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
