
# Slovakia -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://datacube.statistics.sk/#!/view/en/vbd_dem/om7021rr/v_om7021rr_00_00_00_en (retrieved 10 November 2023)
raw_xl <- read_excel(here("data", "02_external_emigration", "sk", "v_om7021rr_00_00_00_en20231110073659.xlsx"), skip = 7)
 
sk_emigration <- raw_xl %>% 
  rename(regionname = `...1`) %>% 
  dplyr::filter(str_detect(regionname, "^Region of")) %>% 
  dplyr::filter(!str_detect(regionname, "NUTS2")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Region of Bratislava" ~ "SK010",
                             regionname == "Region of Trnava" ~ "SK021",
                             regionname == "Region of Trenčín" ~ "SK022",
                             regionname == "Region of Nitra" ~ "SK023",
                             regionname == "Region of Žilina" ~ "SK031",
                             regionname == "Region of Banská Bystrica" ~ "SK032",
                             regionname == "Region of Prešov" ~ "SK041",
                             regionname == "Region of Košice" ~ "SK042")) %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "emigration") %>% 
  mutate(year = as.numeric(year))


## Population -------------------------------------------------------------

# Source: https://datacube.statistics.sk/#!/view/en/vbd_dem/om7011rr/v_om7011rr_00_00_00_en (retrieved 10 November 2023)
raw_xl <- read_excel(here("data", "02_external_emigration", "sk", "v_om7011rr_00_00_00_en20231110074721.xlsx"), skip = 5)

sk_population <- raw_xl %>% 
  rename(regionname = `...1`) %>% 
  dplyr::filter(str_detect(regionname, "^Region of")) %>% 
  dplyr::filter(!str_detect(regionname, "NUTS2")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Region of Bratislava" ~ "SK010",
                             regionname == "Region of Trnava" ~ "SK021",
                             regionname == "Region of Trenčín" ~ "SK022",
                             regionname == "Region of Nitra" ~ "SK023",
                             regionname == "Region of Žilina" ~ "SK031",
                             regionname == "Region of Banská Bystrica" ~ "SK032",
                             regionname == "Region of Prešov" ~ "SK041",
                             regionname == "Region of Košice" ~ "SK042")) %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population") %>% 
  mutate(year = as.numeric(year))


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

sk <- sk_emigration %>%
  left_join(sk_population, by = c("NUTS_ID", "year")) %>% 
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
for (i in 1:(length(sk_election_years) - 1)) {
  start_year <- sk_election_years[i]
  end_year <- sk_election_years[i + 1]
  
  # Filter and summarize emigration
  sum_data <- sk %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(sum_emigration = sum(emigration, na.rm = T))
  
  # Filter and average emigration
  avg_data <- sk %>%
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

sk <- sk %>% 
  left_join(election_emigration, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Export ------------------------------

save(sk, file = here("data", "02_external_emigration", "sk", "sk.Rda"))
