
# Lithuania -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://osp.stat.gov.lt/statistiniu-rodikliu-analize#/ (retrieved 9 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "lt", "emigration.csv"))

lt_emigration <- raw_csv %>% 
  select(-Indicator, -Unit) %>% 
  rename(year = Time,
         regionname = `Administrative territory`,
         emigration = Value) %>% 
  drop_na(emigration) %>% 
  mutate(NUTS_ID = case_when(regionname == "Vilnius county" ~ "LT011",
                             regionname == "Alytus county" ~ "LT021",
                             regionname == "Kaunas county" ~ "LT022",
                             regionname == "Klaipėda county" ~ "LT023",
                             regionname == "Marijampolė county" ~ "LT024",
                             regionname == "Panevėžys county" ~ "LT025",
                             regionname == "Šiauliai county" ~ "LT026",
                             regionname == "Tauragė county" ~ "LT027",
                             regionname == "Telšiai county" ~ "LT028",
                             regionname == "Utena county" ~ "LT029")) %>% 
  select(-regionname)


## Population -------------------------------------------------------------

# Source: https://osp.stat.gov.lt/statistiniu-rodikliu-analize#/ (retrieved 9 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "lt", "population.csv"))

lt_population <- raw_csv %>% 
  select(-c(Indicator, `Place of residence`, Unit)) %>% 
  rename(year = Time,
         regionname = `Administrative territory`,
         population = Value) %>% 
  dplyr::filter(regionname != "Republic of Lithuania",
                regionname != "Central and Western Lithuania Region",
                regionname != "Capital Region") %>% 
  mutate(NUTS_ID = case_when(regionname == "Vilnius county" ~ "LT011",
                             regionname == "Alytus county" ~ "LT021",
                             regionname == "Kaunas county" ~ "LT022",
                             regionname == "Klaipėda county" ~ "LT023",
                             regionname == "Marijampolė county" ~ "LT024",
                             regionname == "Panevėžys county" ~ "LT025",
                             regionname == "Šiauliai county" ~ "LT026",
                             regionname == "Tauragė county" ~ "LT027",
                             regionname == "Telšiai county" ~ "LT028",
                             regionname == "Utena county" ~ "LT029")) %>% 
  select(-regionname)


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

lt <- lt_emigration %>%
  left_join(lt_population, by = c("NUTS_ID", "year")) %>% 
  mutate(emigration_yearly_per_1000 = (emigration/population) * 1000)# %>% 
  # select(NUTS_ID, year, emigration_yearly_per_1000)


## Calculate emigration between elections --------------------------------

# Use sum of emigration in a region between elections
# E.g. 2001, 2002, 2003 and 2004 for election in 2005
# Use average of population in a region between elections
# Calculate emigration per 1000 with this

# Create an empty dataframe to store the results
sum_results <- data.frame()
avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(lt_election_years) - 1)) {
  start_year <- lt_election_years[i]
  end_year <- lt_election_years[i + 1]
  
  # Filter and summarize emigration
  sum_data <- lt %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(sum_emigration = sum(emigration, na.rm = T))
  
  # Filter and average emigration
  avg_data <- lt %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(average_population = mean(population, na.rm = T))
  
  # Add the start and end years for reference
  sum_data$start_year <- start_year
  avg_data$start_year <- start_year
  sum_data$end_year <- end_year - 1
  avg_data$end_year <- end_year - 1
  
  # Append to the results dataframe
  sum_results <- rbind(sum_results, sum_data)
  avg_results <- rbind(avg_results, avg_data)
}

sum_results <- sum_results %>% 
  rename(election_year = end_year) %>% 
  mutate(election_year = election_year + 1) %>% 
  select(NUTS_ID, sum_emigration, election_year)

avg_results <- avg_results %>% 
  rename(election_year = end_year) %>% 
  mutate(election_year = election_year + 1) %>% 
  select(NUTS_ID, average_population, election_year)

election_emigration <- sum_results %>% 
  left_join(avg_results, by = c("NUTS_ID", "election_year")) %>% 
  mutate(emigration_election_year_per_1000 = (sum_emigration/average_population) * 1000) %>% 
  select(NUTS_ID, election_year, emigration_election_year_per_1000)

lt <- lt %>% 
  left_join(election_emigration, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Export ------------------------------

save(lt, file = here("data", "02_external_emigration", "lt", "lt.Rda"))
