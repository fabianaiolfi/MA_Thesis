
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

# Manually add rows, due to mismatch in `year`

# Party information retrieved via https://partyfacts.herokuapp.com/data/partycodes/[pf_party_id]
# https://en.wikipedia.org/wiki/Croatian_Democratic_Alliance_of_Slavonia_and_Baranja
new_row <- data.frame(year = 2011, country_name = "Croatia", v2paenname = NA, pf_party_id = 2347, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)
new_row <- data.frame(year = 2015, country_name = "Croatia", v2paenname = NA, pf_party_id = 2347, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Positive_Slovenia#Parliament
new_row <- data.frame(year = 2014, country_name = "Slovenia", v2paenname = NA, pf_party_id = 1773, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2008_Lithuanian_parliamentary_election#Government_formation
new_row <- data.frame(year = 2008, country_name = "Lithuania", v2paenname = NA, pf_party_id = 1800, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# # https://en.wikipedia.org/wiki/Freedom_and_Solidarity#National_Council
# new_row <- data.frame(year = 2020, country_name = "Slovakia", v2paenname = NA, pf_party_id = 1386, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
# v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Hungarian_Democratic_Forum#National_Assembly
new_row <- data.frame(year = 1998, country_name = "Hungary", v2paenname = NA, pf_party_id = 1697, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Restart_Coalition#Parliamentary_elections
new_row <- data.frame(year = 2015, country_name = "Croatia", v2paenname = NA, pf_party_id = 2522, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Unity_(Hungary)#Election_results
new_row <- data.frame(year = 2014, country_name = "Hungary", v2paenname = NA, pf_party_id = 8265, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# # https://en.wikipedia.org/wiki/Restart_Coalition
# new_row <- data.frame(year = 2020, country_name = "Croatia", v2paenname = NA, pf_party_id = 2522, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
# v_dem_cee <- rbind(v_dem_cee, new_row)

# # https://en.wikipedia.org/wiki/Croatian_Democratic_Union#Legislative
# new_row <- data.frame(year = 2020, country_name = "Croatia", v2paenname = NA, pf_party_id = 1431, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
# v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Democratic_Left_Alliance_%E2%80%93_Labour_Union
new_row <- data.frame(year = 2001, country_name = "Poland", v2paenname = NA, pf_party_id = 6183, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# # https://en.wikipedia.org/wiki/Homeland_Union#Opposition_and_the_third_government_(from_2012)
# new_row <- data.frame(year = 2020, country_name = "Lithuania", v2paenname = NA, pf_party_id = 193, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
# v_dem_cee <- rbind(v_dem_cee, new_row)

# # https://en.wikipedia.org/wiki/Ordinary_People_and_Independent_Personalities#National_Council
# new_row <- data.frame(year = 2020, country_name = "Slovakia", v2paenname = NA, pf_party_id = 2130, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
# v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Democratic_Labour_Party_of_Lithuania#Electoral_results
new_row <- data.frame(year = 2000, country_name = "Lithuania", v2paenname = NA, pf_party_id = 197, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/National_Alliance_(Latvia)#Legislative_elections
new_row <- data.frame(year = 2014, country_name = "Latvia", v2paenname = NA, pf_party_id = 7619, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Alliance_PSD%2BPC#Electoral_history
new_row <- data.frame(year = 2008, country_name = "Romania", v2paenname = NA, pf_party_id = 6153, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE") # TRUE disputable here
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Electoral_Action_of_Poles_in_Lithuania_%E2%80%93_Christian_Families_Alliance#Electoral_results
new_row <- data.frame(year = 2008, country_name = "Lithuania", v2paenname = NA, pf_party_id = 556, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Social_Democratic_Party_of_Lithuania#Seimas
new_row <- data.frame(year = 2004, country_name = "Lithuania", v2paenname = NA, pf_party_id = 2091, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/National_Alliance_(Latvia)#Legislative_elections
new_row <- data.frame(year = 2011, country_name = "Latvia", v2paenname = NA, pf_party_id = 7619, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# # https://en.wikipedia.org/wiki/Electoral_Action_of_Poles_in_Lithuania_%E2%80%93_Christian_Families_Alliance#Electoral_results
# new_row <- data.frame(year = 2020, country_name = "Lithuania", v2paenname = NA, pf_party_id = 556, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
# v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Electoral_Action_of_Poles_in_Lithuania_%E2%80%93_Christian_Families_Alliance#Electoral_results
new_row <- data.frame(year = 2004, country_name = "Lithuania", v2paenname = NA, pf_party_id = 556, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/German_Minority_Electoral_Committee#National_elections and https://en.wikipedia.org/wiki/Democratic_Left_Alliance_%E2%80%93_Labour_Union
new_row <- data.frame(year = 2001, country_name = "Poland", v2paenname = NA, pf_party_id = 1439, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE") # most likely FALSE here
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Conservative_People%27s_Party_of_Estonia#Parliamentary_elections
new_row <- data.frame(year = 2019, country_name = "Estonia", v2paenname = NA, pf_party_id = 4094, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/National_Alliance_(Latvia)#Legislative_elections
new_row <- data.frame(year = 2018, country_name = "Latvia", v2paenname = NA, pf_party_id = 7619, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Lithuanian_Farmers_and_Greens_Union#Electoral_results
new_row <- data.frame(year = 2016, country_name = "Lithuania", v2paenname = NA, pf_party_id = 21, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Democratic_Forum_of_Germans_in_Romania#Legislative_elections
new_row <- data.frame(year = 2004, country_name = "Romania", v2paenname = NA, pf_party_id = 2454, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Isamaa#Parliamentary_elections
new_row <- data.frame(year = 2019, country_name = "Estonia", v2paenname = NA, pf_party_id = 685, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/German_Minority_Electoral_Committee#National_elections and https://en.wikipedia.org/wiki/Democratic_Left_Alliance_%E2%80%93_Labour_Union
new_row <- data.frame(year = 2007, country_name = "Poland", v2paenname = NA, pf_party_id = 1439, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/German_Minority_Electoral_Committee#National_elections and https://en.wikipedia.org/wiki/Democratic_Left_Alliance_%E2%80%93_Labour_Union
new_row <- data.frame(year = 2011, country_name = "Poland", v2paenname = NA, pf_party_id = 1439, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/National_Movement_for_Stability_and_Progress#National_Assembly
new_row <- data.frame(year = 2009, country_name = "Bulgaria", v2paenname = NA, pf_party_id = 374, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Estonian_Free_Party#Parliamentary_elections
new_row <- data.frame(year = 2019, country_name = "Estonia", v2paenname = NA, pf_party_id = 3271, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/League_of_Polish_Families#Election_results
new_row <- data.frame(year = 2007, country_name = "Poland", v2paenname = NA, pf_party_id = 1768, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Greater_Romania_Party#Legislative_elections
new_row <- data.frame(year = 2008, country_name = "Romania", v2paenname = NA, pf_party_id = 1305, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Estonian_Greens#Parliamentary_elections
new_row <- data.frame(year = 2015, country_name = "Estonia", v2paenname = NA, pf_party_id = 1040, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2012_Lithuanian_parliamentary_election#Government_formation
new_row <- data.frame(year = 2012, country_name = "Lithuania", v2paenname = NA, pf_party_id = 1193, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Self-Defence_of_the_Republic_of_Poland#Election_results
new_row <- data.frame(year = 2007, country_name = "Poland", v2paenname = NA, pf_party_id = 727, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Democratic_Forum_of_Germans_in_Romania#Legislative_elections
new_row <- data.frame(year = 2008, country_name = "Romania", v2paenname = NA, pf_party_id = 2454, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Awakening_(political_party)#Saeima
new_row <- data.frame(year = 2018, country_name = "Latvia", v2paenname = NA, pf_party_id = 3193, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Democratic_Forum_of_Germans_in_Romania#Legislative_elections
new_row <- data.frame(year = 2016, country_name = "Romania", v2paenname = NA, pf_party_id = 2454, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/New_Slovenia#National_Assembly
new_row <- data.frame(year = 2008, country_name = "Slovenia", v2paenname = NA, pf_party_id = 1618, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Latvia%27s_First_Party/Latvian_Way
new_row <- data.frame(year = 2011, country_name = "Latvia", v2paenname = NA, pf_party_id = 461, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Democratic_Party_of_Pensioners_of_Slovenia#National_Assembly
new_row <- data.frame(year = 2018, country_name = "Slovenia", v2paenname = NA, pf_party_id = 467, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Alliance_(Slovak_political_party)#National_Council
new_row <- data.frame(year = 2010, country_name = "Slovakia", v2paenname = NA, pf_party_id = 349, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Christian_Democratic_Movement#National_Council
new_row <- data.frame(year = 2016, country_name = "Slovakia", v2paenname = NA, pf_party_id = 63, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/People%27s_Party_%E2%80%93_Movement_for_a_Democratic_Slovakia#National_Council_of_the_Slovak_Republic
new_row <- data.frame(year = 2012, country_name = "Slovakia", v2paenname = NA, pf_party_id = 560, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Croatian_Labourists_%E2%80%93_Labour_Party#Legislative
new_row <- data.frame(year = 2016, country_name = "Croatia", v2paenname = NA, pf_party_id = 3143, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Green_Party_(Czech_Republic)#Chamber_of_Deputies_of_the_Czech_Republic
new_row <- data.frame(year = 2010, country_name = "Czechia", v2paenname = NA, pf_party_id = 1554, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Estonian_Greens#Parliamentary_elections
new_row <- data.frame(year = 2011, country_name = "Estonia", v2paenname = NA, pf_party_id = 1040, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Nonpartisan_Local_Government_Activists#Election_results
new_row <- data.frame(year = 2019, country_name = "Poland", v2paenname = NA, pf_party_id = NA, v2pashname = "BS", v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/People%27s_Party_%E2%80%93_Movement_for_a_Democratic_Slovakia#National_Council_of_the_Slovak_Republic
new_row <- data.frame(year = 2010, country_name = "Slovakia", v2paenname = NA, pf_party_id = 560, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/People%27s_Party_%E2%80%93_Movement_for_a_Democratic_Slovakia#National_Council_of_the_Slovak_Republic
new_row <- data.frame(year = 2010, country_name = "Slovakia", v2paenname = NA, pf_party_id = 560, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Christian_Democratic_People%27s_Party_%28Hungary%29#National_Assembly
new_row <- data.frame(year = 1998, country_name = "Hungary", v2paenname = NA, pf_party_id = 1412, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Liberal_Democracy_of_Slovenia#Parliament
new_row <- data.frame(year = 2011, country_name = "Slovenia", v2paenname = NA, pf_party_id = 975, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Latvian_Social_Democratic_Workers%27_Party#Legislative_elections
new_row <- data.frame(year = 2011, country_name = "Latvia", v2paenname = NA, pf_party_id = 741, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Communist_Party_of_Slovakia#Electoral_results
new_row <- data.frame(year = 2010, country_name = "Slovakia", v2paenname = NA, pf_party_id = 340, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Slovenian_National_Party#National_Assembly
new_row <- data.frame(year = 2011, country_name = "Slovenia", v2paenname = NA, pf_party_id = 96, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Greater_Romania_Party#Legislative_elections
new_row <- data.frame(year = 2012, country_name = "Romania", v2paenname = NA, pf_party_id = 1305, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Slovenian_People%27s_Party#National_Assembly
new_row <- data.frame(year = 2014, country_name = "Slovenia", v2paenname = NA, pf_party_id = 764, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Reformist_Bloc#Elections
new_row <- data.frame(year = 2017, country_name = "Bulgaria", v2paenname = NA, pf_party_id = 3189, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/KDU-%C4%8CSL#Legislative_elections_2
new_row <- data.frame(year = 2010, country_name = "Czechia", v2paenname = NA, pf_party_id = 676, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)


#na_check %>% arrange(vote_change)


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
ned$partyfacts_id[ned$party_abbreviation == "PATRIOTIC"] <- 3918 # https://partyfacts.herokuapp.com/data/partycodes/3918/
ned$partyfacts_id[ned$party_abbreviation == "MSZP-PARBESZED"] <- 1408 # https://en.wikipedia.org/wiki/Hungarian_Socialist_Party https://en.wikipedia.org/wiki/Dialogue_%E2%80%93_The_Greens%27_Party 
ned$partyfacts_id[ned$party_abbreviation == "AP!"] <- 8393 

# Preprocess and add vote share
ned_cee <- ned %>% 
  dplyr::filter(country %in% cee_names) %>%
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year >= 1994 & year < 2020) %>% 
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

# ggplot(na_check, aes(x=prev_incumbent, y=vote_change)) +
#   geom_boxplot()
# 
# ned_cee %>% dplyr::filter(country == "Croatia") %>% distinct(year) %>% arrange(year)
# v_dem_cee %>% dplyr::filter(country_name == "Croatia") %>% distinct(year) %>% arrange(year)


#ned_cee %>% distinct(year) %>% arrange(year) %>% print()











