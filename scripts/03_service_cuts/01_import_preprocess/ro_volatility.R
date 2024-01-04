
# Electoral Volatility --------------------------------

## Using entire NED dataset ---------------------------------

# Import NED
ned <- read.csv(here("data", "eu_ned_joint.csv"))

# Format DF
ro_volatility <- ned %>% 
  dplyr::filter(country == "Romania") %>% 
  dplyr::filter(type == "Parliament") %>% 
  dplyr::filter(regionname != "Abroad votes") %>% 
  mutate(vote_share = partyvote / totalvote * 100) %>% 
  select(year, nuts2016, party_abbreviation, partyfacts_id, vote_share) %>% 
  group_by(nuts2016) %>% 
  arrange(year) %>% 
  mutate(year = paste0("y_", year)) %>% 
  pivot_wider(names_from = year, values_from = vote_share) %>% 
  ungroup()

# Convert NAs to 0
ro_volatility[is.na(ro_volatility)] <- 0

# Calculate volatility
ro_volatility <- ro_volatility %>%
  group_by(nuts2016) %>%
  mutate(volatility_2008 = volatility(y_2004, y_2008)) %>% 
  mutate(volatility_2012 = volatility(y_2008, y_2012)) %>%
  mutate(volatility_2016 = volatility(y_2012, y_2016))

# Prepare for export
ro_volatility <- ro_volatility %>%
  select(nuts2016, volatility_2008, volatility_2012, volatility_2016) %>%
  distinct(nuts2016, .keep_all = T) %>% 
  pivot_longer(cols = -nuts2016,
               names_to = "year",
               values_to = "volatility") %>% 
  mutate(year = gsub("volatility_", "", year)) %>% 
  mutate(year = as.numeric(year))


## Using dataset combined with V-DEM ---------------------------------

# # Format DF
# ro_volatility <- ned_v_dem_cee %>% 
#   dplyr::filter(country == "Romania") %>% 
#   select(year, nuts2016, unique_party_id, vote_share) %>% 
#   group_by(nuts2016) %>% 
#   arrange(year) %>% 
#   mutate(year = paste0("y_", year)) %>% 
#   pivot_wider(names_from = year, values_from = vote_share) %>% 
#   ungroup()
# 
# # Convert NAs to 0
# ro_volatility[is.na(ro_volatility)] <- 0
# 
# # Calculate volatility
# ro_volatility <- ro_volatility %>% 
#   group_by(nuts2016) %>% 
#   mutate(volatility_2012 = volatility(y_2008, y_2012)) %>% 
#   mutate(volatility_2016 = volatility(y_2012, y_2016))
# 
# # Prepare for export
# ro_volatility <- ro_volatility %>% 
#   select(nuts2016, volatility_2012, volatility_2016) %>% 
#   distinct(nuts2016, .keep_all = T)
  

## Export ------------------------------

save(ro_volatility, file = here("data", "03_service_cuts", "ro", "ro_volatility.Rda"))
