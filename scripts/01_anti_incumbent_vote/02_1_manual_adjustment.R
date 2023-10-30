
# Manually add rows, due to mismatch in `year`
# Government support leading up to an election is coded as "incumbent", thus "TRUE"
# (e.g., `pf_party_id = 96` and https://en.wikipedia.org/wiki/Slovenian_National_Party#Electoral_results).
# (e.g., `pf_party_id = 1305` and https://en.wikipedia.org/wiki/Greater_Romania_Party#Electoral_history).
# Limited to:
# `vote_share` >= 4
# `vote_change` >= |1|

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

# https://en.wikipedia.org/wiki/Hungarian_Democratic_Forum#National_Assembly
new_row <- data.frame(year = 1998, country_name = "Hungary", v2paenname = NA, pf_party_id = 1697, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Restart_Coalition#Parliamentary_elections
new_row <- data.frame(year = 2015, country_name = "Croatia", v2paenname = NA, pf_party_id = 2522, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Unity_(Hungary)#Election_results
new_row <- data.frame(year = 2014, country_name = "Hungary", v2paenname = NA, pf_party_id = 8265, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Democratic_Left_Alliance_%E2%80%93_Labour_Union
new_row <- data.frame(year = 2001, country_name = "Poland", v2paenname = NA, pf_party_id = 6183, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

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

# https://en.wikipedia.org/wiki/2016_Croatian_parliamentary_election#Results
new_row <- data.frame(year = 2016, country_name = "Croatia", v2paenname = NA, pf_party_id = NA, v2pashname = "EVEN STRONGER ISTRIA", v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2015_Croatian_parliamentary_election#Results
new_row <- data.frame(year = 2015, country_name = "Croatia", v2paenname = NA, pf_party_id = 2650, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/New_Hope_(Poland)#Election_results
new_row <- data.frame(year = 2019, country_name = "Poland", v2paenname = NA, pf_party_id = 4629, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/New_Hope_(Poland)#Election_results
new_row <- data.frame(year = 2018, country_name = "Slovenia", v2paenname = NA, pf_party_id = 96, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Green_Party_(Czech_Republic)#Election_results
new_row <- data.frame(year = 2013, country_name = "Czechia", v2paenname = NA, pf_party_id = 1554, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/New_Slovenia#Electoral_results
new_row <- data.frame(year = 2011, country_name = "Slovenia", v2paenname = NA, pf_party_id = 1618, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Hungarian_Workers%27_Party#Election_results
new_row <- data.frame(year = 1998, country_name = "Hungary", v2paenname = NA, pf_party_id = 859, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Party_of_Civic_Rights#Election_results
new_row <- data.frame(year = 2013, country_name = "Czechia", v2paenname = NA, pf_party_id = 1272, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Latvian_Russian_Union#Election_results
new_row <- data.frame(year = 2010, country_name = "Latvia", v2paenname = NA, pf_party_id = 176, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Hungarian_Workers%27_Party#Election_results
new_row <- data.frame(year = 2002, country_name = "Hungary", v2paenname = NA, pf_party_id = 859, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Hungarian_Justice_and_Life_Party#Parliamentary_representation
new_row <- data.frame(year = 2002, country_name = "Hungary", v2paenname = NA, pf_party_id = 1597, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2016_Croatian_parliamentary_election#Results
new_row <- data.frame(year = 2016, country_name = "Croatia", v2paenname = NA, pf_party_id = 2650, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2012_Lithuanian_parliamentary_election#Results
new_row <- data.frame(year = 2012, country_name = "Lithuania", v2paenname = NA, pf_party_id = 1250, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Bulgarian_Democratic_Center#Participation_in_elections
new_row <- data.frame(year = 2013, country_name = "Bulgaria", v2paenname = NA, pf_party_id = 265, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Attack_%28political_party%29#National_Assembly
new_row <- data.frame(year = 2014, country_name = "Bulgaria", v2paenname = NA, pf_party_id = 1793, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2017_Czech_parliamentary_election#Results
new_row <- data.frame(year = 2017, country_name = "Czechia", v2paenname = NA, pf_party_id = 254, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Young_Lithuania#Election_results
new_row <- data.frame(year = 2012, country_name = "Lithuania", v2paenname = NA, pf_party_id = 1026, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Slovenian_People%27s_Party#Electoral_results
new_row <- data.frame(year = 2018, country_name = "Slovenia", v2paenname = NA, pf_party_id = 764, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Order,_Law_and_Justice#History
new_row <- data.frame(year = 2013, country_name = "Bulgaria", v2paenname = NA, pf_party_id = 272, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Constitution_Party_(Estonia)#Election_results
new_row <- data.frame(year = 2007, country_name = "Estonia", v2paenname = NA, pf_party_id = 18, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/People%27s_Union_of_Estonia#Parliamentary_elections
new_row <- data.frame(year = 2011, country_name = "Estonia", v2paenname = NA, pf_party_id = 110, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Estonian_Greens#Parliamentary_elections
new_row <- data.frame(year = 2019, country_name = "Estonia", v2paenname = NA, pf_party_id = 1040, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2015_Croatian_parliamentary_election#Government_formation
new_row <- data.frame(year = 2015, country_name = "Croatia", v2paenname = NA, pf_party_id = 2524, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Greater_Romania_Party#Electoral_history
new_row <- data.frame(year = 2016, country_name = "Romania", v2paenname = NA, pf_party_id = 1305, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Hungarian_Democratic_Forum#Election_results
new_row <- data.frame(year = 2010, country_name = "Hungary", v2paenname = NA, pf_party_id = 1697, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Hungarian_People%27s_Party_of_Transylvania#Legislative_elections
new_row <- data.frame(year = 2012, country_name = "Romania", v2paenname = NA, pf_party_id = NA, v2pashname = "PPMT", v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Development/For!#Legislative_elections
new_row <- data.frame(year = 2018, country_name = "Latvia", v2paenname = NA, pf_party_id = 8393, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2015_Polish_parliamentary_election#Results
new_row <- data.frame(year = 2015, country_name = "Poland", v2paenname = NA, pf_party_id = 1439, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2019_Polish_parliamentary_election#Results
new_row <- data.frame(year = 2019, country_name = "Poland", v2paenname = NA, pf_party_id = 1439, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Electoral_Action_of_Poles_in_Lithuania_%E2%80%93_Christian_Families_Alliance#Electoral_results
new_row <- data.frame(year = 2000, country_name = "Lithuania", v2paenname = NA, pf_party_id = 556, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/National_Alliance_(Latvia)#Election_results
new_row <- data.frame(year = 2010, country_name = "Latvia", v2paenname = NA, pf_party_id = 7619, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/United_Patriots#Electoral_history
new_row <- data.frame(year = 2017, country_name = "Bulgaria", v2paenname = NA, pf_party_id = 6115, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Labour_Party_(Lithuania)#Electoral_results
new_row <- data.frame(year = 2008, country_name = "Lithuania", v2paenname = NA, pf_party_id = 8279, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Conservative_People%27s_Party_of_Estonia#Electoral_results
new_row <- data.frame(year = 2015, country_name = "Estonia", v2paenname = NA, pf_party_id = 4094, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Independent_Democratic_Serb_Party#Croatian_Parliament
new_row <- data.frame(year = 2011, country_name = "Croatia", v2paenname = NA, pf_party_id = 2348, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Free_Forum
new_row <- data.frame(year = 2006, country_name = "Slovakia", v2paenname = NA, pf_party_id = 137, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Momentum_Movement#National_Assembly
new_row <- data.frame(year = 2018, country_name = "Hungary", v2paenname = NA, pf_party_id = 8249, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Latvian_Association_of_Regions#Legislative_elections
new_row <- data.frame(year = 2018, country_name = "Latvia", v2paenname = NA, pf_party_id = 3194, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/The_Key_of_Croatia#Parliament_(Sabor)
new_row <- data.frame(year = 2015, country_name = "Croatia", v2paenname = NA, pf_party_id = 4867, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/New_Hope_(Poland)#Sejm
new_row <- data.frame(year = 2015, country_name = "Poland", v2paenname = NA, pf_party_id = 4629, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Republican_Party_(Hungary)#Election_results
new_row <- data.frame(year = 1994, country_name = "Hungary", v2paenname = NA, pf_party_id = 3795, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Estonia_200#Parliamentary_elections
new_row <- data.frame(year = 2019, country_name = "Estonia", v2paenname = NA, pf_party_id = 7340, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Party_of_Alenka_Bratu%C5%A1ek#National_Assembly
new_row <- data.frame(year = 2014, country_name = "Slovenia", v2paenname = NA, pf_party_id = 3114, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Lithuanian_Farmers_and_Greens_Union#Seimas
new_row <- data.frame(year = 2004, country_name = "Lithuania", v2paenname = NA, pf_party_id = 3971, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/Latvian_Way#Electoral_results
new_row <- data.frame(year = 2002, country_name = "Latvia", v2paenname = NA, pf_party_id = 1043, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2016_Lithuanian_parliamentary_election#Results
new_row <- data.frame(year = 2016, country_name = "Lithuania", v2paenname = NA, pf_party_id = 5456, v2pashname = NA, v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# https://en.wikipedia.org/wiki/2014_Bulgarian_parliamentary_election#Government_formation
new_row <- data.frame(year = 2014, country_name = "Bulgaria", v2paenname = NA, pf_party_id = 5649, v2pashname = NA, v2pagovsup = NA, incumbent = "TRUE")
v_dem_cee <- rbind(v_dem_cee, new_row)

# Assuming that independents are never incumbents
new_row <- data.frame(year = NA, country_name = "Romania", v2paenname = NA, pf_party_id = NA, v2pashname = "INDEPENDENT", v2pagovsup = NA, incumbent = "FALSE")
v_dem_cee <- rbind(v_dem_cee, new_row)
