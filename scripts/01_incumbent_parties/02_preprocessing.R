
# Preprocessing -----------------------------------------------------------

## V-DEM -----------------------------------------------------------

v_dem_cee <- v_dem %>% 
  dplyr::filter(country_name %in% cee_names) %>% 
  dplyr::filter(year >= 1994) %>% 
  select(year, country_name, v2paenname, pf_party_id, v2pashname, v2pagovsup) %>% 
  mutate(incumbent = case_when(v2pagovsup == 0 ~ T,
                               v2pagovsup == 1 ~ T,
                               v2pagovsup == 2 ~ T,
                               v2pagovsup == 3 ~ F,
                               v2pagovsup == 4 ~ NA))

# Problem:
# incumbent column has to provide information about incumbant status *of previous election*,
# i.e., "was party incumbent after last election?"
# This means column should read something like "incumbent_last_election" and should probably be country specific, as every country has different voting intervalls

# v_dem_cee_incumbent_parties <- v_dem_cee %>% 
#   dplyr::filter(incumbent == T) %>% 
#   select(-incumbent)


## NED -----------------------------------------------------------

ned_cee <- ned %>% 
  dplyr::filter(country %in% cee_names) %>%
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year >= 1994) %>% 
  dplyr::filter(regionname != "Abroad votes") %>% 
  dplyr::filter(party_abbreviation != "OTHER") %>% 
  mutate(vote_share = partyvote / totalvote * 100) %>% 
  select(year, country, nutslevel, nuts2016, regionname, party_abbreviation, party_english, partyfacts_id, vote_share)

# Assuming your dataframe is named df
ned_cee <- ned_cee %>%
  arrange(nuts2016, partyfacts_id, year) %>%
  group_by(nuts2016, partyfacts_id) %>%
  mutate(vote_change = vote_share - dplyr::lag(vote_share, order_by = year))


# Merge V-DEM and NED -----------------------------------------------------------

test <- v_dem_cee %>% distinct(year, country_name, v2paenname, pf_party_id)

test_merge <- ned_cee %>% 
  left_join(select(v_dem_cee, year, pf_party_id, incumbent), by = c("year" = "year", "partyfacts_id" = "pf_party_id"))





