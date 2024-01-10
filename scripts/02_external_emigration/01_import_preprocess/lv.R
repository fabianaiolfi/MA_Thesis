
# Latvia -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://data.stat.gov.lv/pxweb/en/OSP_PUB/START__POP__IB__IBE/IBE080/table/tableViewLayout1/ (retrieved 9 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "lv", "IBE080_20231109-184935.csv"),
                      delim = ";",
                      skip = 1)
 
lv_emigration <- raw_csv %>% 
  rename(regioname = `Territorial unit`) %>% 
  select(-Indicator) %>% 
  pivot_longer(
    cols = -regioname, 
    names_to = "year",
    values_to = "emigration") %>% 
  mutate(NUTS_ID = case_when(regioname == "Kurzeme region" ~ "LV003",
                             regioname == "Latgale region" ~ "LV005",
                             regioname == "Riga region" ~ "LV006",
                             regioname == "Pierīga region" ~ "LV007",
                             regioname == "Vidzeme region" ~ "LV008",
                             regioname == "Zemgale region" ~ "LV009")) %>% 
  mutate(year = as.numeric(year)) %>% 
  select(-regioname)


## Population -------------------------------------------------------------

# Source: https://data.stat.gov.lv/pxweb/en/OSP_PUB/START__POP__IR__IRS/IRS030/table/tableViewLayout1/ (retrieved 9 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "lv", "IRS030_20231109-185354.csv"),
                      delim = ";",
                      skip = 1)

lv_population <- raw_csv %>% 
  rename(regioname = `Territorial unit`) %>% 
  select(-Indicator) %>% 
  pivot_longer(
    cols = -regioname, 
    names_to = "year",
    values_to = "population") %>% 
  mutate(NUTS_ID = case_when(regioname == "Kurzeme region" ~ "LV003",
                             regioname == "Latgale region" ~ "LV005",
                             regioname == "Riga region" ~ "LV006",
                             regioname == "Pierīga region" ~ "LV007",
                             regioname == "Vidzeme region" ~ "LV008",
                             regioname == "Zemgale region" ~ "LV009")) %>% 
  mutate(year = as.numeric(year)) %>% 
  select(-regioname)


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

lv <- lv_emigration %>%
  left_join(lv_population, by = c("NUTS_ID", "year")) %>% 
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
for (i in 1:(length(lv_election_years) - 1)) {
  start_year <- lv_election_years[i]
  end_year <- lv_election_years[i + 1]
  
  # Filter and summarize emigration
  sum_data <- lv %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(sum_emigration = sum(emigration, na.rm = T))
  
  # Filter and average emigration
  avg_data <- lv %>%
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

lv <- lv %>% 
  left_join(election_emigration, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Export ------------------------------

save(lv, file = here("data", "02_external_emigration", "lv", "lv.Rda"))
