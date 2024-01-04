
# Electoral Volatility --------------------------------

## Using entire NED dataset ---------------------------------

# Import NED
ned <- read.csv(here("data", "eu_ned_joint.csv"))

# Format DF
pl_volatility <- ned %>% 
  dplyr::filter(country == "Poland") %>% 
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
pl_volatility[is.na(pl_volatility)] <- 0

# Calculate volatility
pl_volatility <- pl_volatility %>%
  group_by(nuts2016) %>%
  mutate(volatility_2005 = volatility(y_2001, y_2005)) %>% 
  mutate(volatility_2007 = volatility(y_2005, y_2007)) %>%
  mutate(volatility_2011 = volatility(y_2007, y_2011)) %>% 
  mutate(volatility_2015 = volatility(y_2011, y_2015)) %>% 
  mutate(volatility_2019 = volatility(y_2015, y_2019))

# Prepare for export
pl_volatility <- pl_volatility %>%
  select(nuts2016, volatility_2005, volatility_2007, volatility_2011, volatility_2015, volatility_2019) %>%
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

save(pl_volatility, file = here("data", "03_service_cuts", "pl", "pl_volatility.Rda"))
