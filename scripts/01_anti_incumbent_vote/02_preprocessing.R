
# Preprocessing -----------------------------------------------------------

## V-DEM -----------------------------------------------------------

v_dem_cee <- v_dem %>% 
  dplyr::filter(country_name %in% cee_names) %>% 
  dplyr::filter(year >= 1994) %>% 
  select(year, country_name, v2paenname, pf_party_id, v2pashname, v2pagovsup) %>% 
  mutate(incumbent = case_when(v2pagovsup == 0 ~ "TRUE",
                               v2pagovsup == 1 ~ "TRUE",
                               v2pagovsup == 2 ~ "TRUE",
                               v2pagovsup == 3 ~ "FALSE",
                               v2pagovsup == 4 ~ "Temp NA",
                               is.na(v2pagovsup) == T ~ "Temp NA"))

# Manually add rows

# Party information retrieved via https://partyfacts.herokuapp.com/data/partycodes/[pf_party_id]
# https://en.wikipedia.org/wiki/Croatian_Democratic_Alliance_of_Slavonia_and_Baranja
new_row <- data.frame(year = 2011, country_name = "Croatia", v2paenname = NA, pf_party_id = 2347, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)
new_row <- data.frame(year = 2015, country_name = "Croatia", v2paenname = NA, pf_party_id = 2347, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Positive_Slovenia
new_row <- data.frame(year = 2014, country_name = "Slovenia", v2paenname = NA, pf_party_id = 1773, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2008_Lithuanian_parliamentary_election#Government_formation
new_row <- data.frame(year = 2008, country_name = "Lithuania", v2paenname = NA, pf_party_id = 1800, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Freedom_and_Solidarity#National_Council
new_row <- data.frame(year = 2020, country_name = "Slovakia", v2paenname = NA, pf_party_id = 1386, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Hungarian_Democratic_Forum#National_Assembly
new_row <- data.frame(year = 1998, country_name = "Hungary", v2paenname = NA, pf_party_id = 1697, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Restart_Coalition#Parliamentary_elections
new_row <- data.frame(year = 2015, country_name = "Croatia", v2paenname = NA, pf_party_id = 2522, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Unity_(Hungary)#Election_results
new_row <- data.frame(year = 2014, country_name = "Hungary", v2paenname = NA, pf_party_id = 8265, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Restart_Coalition
new_row <- data.frame(year = 2020, country_name = "Croatia", v2paenname = NA, pf_party_id = 2522, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Croatian_Democratic_Union#Legislative
new_row <- data.frame(year = 2020, country_name = "Croatia", v2paenname = NA, pf_party_id = 1431, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# Problem:
# incumbent column has to provide information about incumbant status *of previous election*,
# i.e., "was party incumbent after last election?"
# This means column should read something like "incumbent_last_election" and should probably be country specific, as every country has different voting intervalls

# Was party incumbent in previous election?
v_dem_cee <- v_dem_cee %>%
  arrange(year, pf_party_id) %>%
  group_by(pf_party_id) %>%
  mutate(prev_incumbent = dplyr::lag(incumbent, order_by = year)) %>% 
  mutate(prev_incumbent = if_else(is.na(prev_incumbent) & row_number() == 1, "Temp NA", as.character(prev_incumbent))) %>% 
  ungroup()


## NED -----------------------------------------------------------

# Fix typos
ned$partyfacts_id[ned$party_abbreviation == "SLP-UP"] <- 6183

# Preprocess and add vote share
ned_cee <- ned %>% 
  dplyr::filter(country %in% cee_names) %>%
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year >= 1994) %>% 
  dplyr::filter(regionname != "Abroad votes") %>% 
  dplyr::filter(party_abbreviation != "OTHER") %>% 
  mutate(vote_share = partyvote / totalvote * 100) %>% 
  select(year, country, nutslevel, nuts2016, regionname, party_abbreviation, party_english, partyfacts_id, vote_share)

# Add party's vote change between two consecutive elections
ned_cee <- ned_cee %>%
  arrange(nuts2016, partyfacts_id, year) %>%
  group_by(nuts2016, partyfacts_id) %>%
  mutate(vote_change = vote_share - dplyr::lag(vote_share, order_by = year)) %>% 
  ungroup()


# Merge V-DEM and NED -----------------------------------------------------------

#test <- v_dem_cee %>% distinct(year, country_name, v2paenname, pf_party_id)

na_check <- ned_cee %>% 
  left_join(select(v_dem_cee, year, pf_party_id, prev_incumbent), by = c("year" = "year", "partyfacts_id" = "pf_party_id")) %>% 
  dplyr::filter(is.na(prev_incumbent) == T) %>% 
  distinct(year, partyfacts_id, .keep_all = T)

# ggplot(test_merge, aes(x=prev_incumbent, y=vote_change)) + 
#   geom_boxplot()
# 
# ned_cee %>% dplyr::filter(country == "Croatia") %>% distinct(year) %>% arrange(year)
# v_dem_cee %>% dplyr::filter(country_name == "Croatia") %>% distinct(year) %>% arrange(year)















