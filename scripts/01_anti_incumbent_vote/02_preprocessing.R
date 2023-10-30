
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
source(here("scripts", "01_anti_incumbent_vote", "02_1_manual_adjustment.R"))

# Was party incumbent in previous election?
v_dem_cee <- v_dem_cee %>%
  arrange(year, pf_party_id) %>%
  group_by(pf_party_id) %>%
  mutate(prev_incumbent = dplyr::lag(incumbent, order_by = year)) %>% 
  mutate(prev_incumbent = if_else(is.na(prev_incumbent) & row_number() == 1, "Temp NA", as.character(prev_incumbent))) %>% 
  ungroup()


## NED -----------------------------------------------------------

# Manually fix typos or ID NAs
source(here("scripts", "01_anti_incumbent_vote", "02_2_fix_nas.R"))

# Preprocess and add vote share
ned_cee <- ned %>% 
  dplyr::filter(country %in% cee_names) %>%
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(year >= 1994 & year < 2020) %>% 
  dplyr::filter(regionname != "Abroad votes") %>% 
  dplyr::filter(party_abbreviation != "OTHER") %>% 
  mutate(vote_share = partyvote / totalvote * 100) %>% 
  select(year, country, nutslevel, nuts2016, regionname, party_abbreviation, party_english, partyfacts_id, vote_share)

# Give each Party a unique ID
ned_cee$unique_party_id <- ned_cee$partyfacts_id

# Identify max ID in current dataframe
max_id <- max(ned_cee$unique_party_id, na.rm = TRUE)

# Create a function to generate a new unique ID
generate_new_id <- function() {
  max_id <<- max_id + 1
  return(max_id)
}

# Create a function to fill in missing IDs for parties
fill_ids <- function(data) {
  # If any ID exists for the party, use that
  existing_id <- unique(data$unique_party_id[!is.na(data$unique_party_id)])
  if(length(existing_id) > 0) {
    return(existing_id)
  } else {
    return(generate_new_id())
  }
}

# Group by party and fill missing IDs
ned_cee <- ned_cee %>%
  group_by(party_abbreviation, party_english, country) %>%
  mutate(unique_party_id = fill_ids(data.frame(unique_party_id))) %>%
  ungroup()

# Add party's vote change between two consecutive elections
ned_cee <- ned_cee %>%
  arrange(nuts2016, unique_party_id, year) %>%
  group_by(nuts2016, unique_party_id) %>%
  mutate(vote_change = vote_share - dplyr::lag(vote_share, order_by = year)) %>% 
  ungroup() %>% 
  # Fixes bug where parties with same ID but different names had vote_change within same election
  distinct(year, country, nuts2016, unique_party_id, .keep_all = T)


# Merge V-DEM and NED -----------------------------------------------------------

ned_v_dem_cee <- ned_cee %>% 
  # Merge dataframes
  left_join(select(v_dem_cee, year, pf_party_id, prev_incumbent),
            by = c("year" = "year",
                   "unique_party_id" = "pf_party_id")) %>% 
  # Turn prev_incumbent into binary variable
  mutate(prev_incumbent = case_when(prev_incumbent == "Temp NA" ~ NA,
                                    is.na(prev_incumbent) == T ~ NA,
                                    prev_incumbent == "TRUE" ~ T,
                                    prev_incumbent == "FALSE" ~ F)) %>% 
  # Hack to prevent party id 3918 from appearing twice
  distinct(unique_party_id, vote_share, .keep_all = T)

# Keep your eye out for these parties
# They appear twice in the same election
# However, they don't seem to be incumbents, so they can probably be ignored
v_dem_cee_distinct <- v_dem_cee %>% distinct(year, pf_party_id, .keep_all = T)
missing_rows <- anti_join(v_dem_cee, v_dem_cee_distinct)


# t-test -----------------------------------------------------------

ned_v_dem_cee %>% 
  drop_na(vote_change, prev_incumbent) %>% 
  ggplot(aes(x = prev_incumbent, y = vote_change)) +
  geom_boxplot() +
  xlab("") +
  ggtitle(label = "Was Party in Power in Previous Election?",
          subtitle = "11 CEE EU Member States, NUTS2/3, 1994–2019") +
  ylab("Change in Vote Share") +
  scale_x_discrete(labels = c("No", "Yes")) +
  theme_minimal()

# Split the scores based on the binary_var
group_true <- ned_v_dem_cee$vote_change[ned_v_dem_cee$prev_incumbent == TRUE]
group_false <- ned_v_dem_cee$vote_change[ned_v_dem_cee$prev_incumbent == FALSE]

# Perform the t-test
result <- t.test(group_true, group_false)
result
