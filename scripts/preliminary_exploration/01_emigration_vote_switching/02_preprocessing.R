
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
  

# Fix avg NAs -------------------------------------------------------------
# LT and SI use NUTS3 from 2010

nuts3_2010_clean <- nuts3_2010 %>% 
  dplyr::filter(level == 3) %>% 
  select(Code.2010, NUTS.level.3)

migr <- migr %>% 
  left_join(nuts3_2010_clean, by = c("GEO (Labels)" = "NUTS.level.3"))

# Replace Lithuanian and Slovenian NUTS3 Codes
migr <- migr %>%
  mutate(`GEO (Codes)` = ifelse(startsWith(`GEO (Codes)`, "LT"), `Code.2010`, `GEO (Codes)`)) %>% 
  mutate(`GEO (Codes)` = ifelse(startsWith(`GEO (Codes)`, "SI"), `Code.2010`, `GEO (Codes)`))


# Prepare NUTS3 Migration Data -------------------------------------------------------------

net_migr_nuts3 <- migr %>% 
  select(`GEO (Codes)`, `2009`:`2019`) %>% 
  # Timeframe can be questioned here
  mutate(avg_migr = rowMeans(select(., `2009`:`2019`), na.rm = TRUE)) %>% 
  select(`GEO (Codes)`, avg_migr)


# Merge Switchers with NUTS3 Migration -------------------------------------------------------------

ees_cee_nuts3 <- ees_cee_nuts3 %>% 
  left_join(net_migr_nuts3, by = c("region_NUTS3" = "GEO (Codes)"))
