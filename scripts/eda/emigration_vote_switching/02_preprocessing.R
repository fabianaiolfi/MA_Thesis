
# Preprocessing -------------------------------------------------------------

# Prepare EES Data -------------------------------------------------------------

# Only keep CEE observations that have NUTS3 value

cee <- c(1110, #"Bulgaria",
         1191, #"Croatia",
         1203, #"Czech Rep.",
         1233, #"Estonia",
         1348, #"Hungary",
         1428, #"Latvia",
         1440, #"Lithuania",
         1616, #"Poland",
         1642, #"Romania",
         1703, #"Slovakia",
         1705) #"Slovenia")

# Subset CEE NUTS3 and clean dataset
ees_cee_nuts3 <- ees %>%
  dplyr::filter(region_NUTS3 != 96) %>%
  dplyr::filter(countrycode %in% cee) %>% 
  select(region_NUTS3, Q9n, q10_1:q10_10) %>% 
  dplyr::filter(!Q9n %in% c(0, 20, 90, 96, 97, 98, 99)) %>% # Remove other, don't know, didn't vote, etc.
  mutate_at(vars(q10_1:q10_10), ~ifelse(. %in% c(96, 97, 98), NA, .)) # Replace refusal, don't know with NAs

# Retrieve party voter will most likely to vote for
# To Do: If voter gives two or more parties the same value, then the first party on the list is picked. Should be optimised if one of the parties is the party the voter last voted for.
ees_cee_nuts3 <- ees_cee_nuts3 %>%
  rowwise() %>%
  mutate(q10_max = list(names(select(ees_cee_nuts3, q10_1:q10_10))[which.max(c_across(q10_1:q10_10))])) %>%
  ungroup() %>% 
  mutate(q10_max = gsub('q10_', '', q10_max)) %>% 
  mutate(q10_max = as.numeric(q10_max))

# Is voter a switcher?
ees_cee_nuts3 <- ees_cee_nuts3 %>%
  drop_na(q10_max) %>% 
  mutate(switcher = case_when(Q9n != q10_max ~ TRUE,
                              Q9n == q10_max ~ FALSE)) %>% 
  select(region_NUTS3, switcher)
  

# Prepare NUTS3 Migration Data -------------------------------------------------------------

net_migr_nuts3 <- migr %>% 
  select(`GEO (Codes)`, `2015`:`2019`) %>% 
  # Timeframe can be questioned here
  mutate(avg = rowMeans(select(., `2015`:`2019`), na.rm = TRUE)) %>% 
  select(`GEO (Codes)`, avg)

# Merge Switchers with NUTS3 Migration -------------------------------------------------------------

ees_cee_nuts3 <- ees_cee_nuts3 %>% 
  left_join(net_migr_nuts3, by = c("region_NUTS3" = "GEO (Codes)"))


