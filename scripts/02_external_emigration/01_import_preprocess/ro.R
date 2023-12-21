
# Romania -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (retrieved 13 November 2023)
# Original file must be resaved as from XLS to XLSX
raw_xl <- read_excel(here("data", "02_external_emigration", "ro", "TEMPO_POP309E_1_10_2023.xlsx"), skip = 2)
 
ro_emigration <- raw_xl %>% 
  drop_na(`...1`, `Year 2000`) %>% 
  select(-`...2`) %>% 
  rename(regionname = `...1`) %>% 
  dplyr::filter(regionname != "TOTAL") %>% 
  left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN"))

# Which regions didn't make it in the join?
# Manuall add them
#missing_nuts <- ro_emigration %>% select(regionname, NUTS_ID) %>% dplyr::filter(is.na(NUTS_ID) == T)

ro_emigration <- ro_emigration %>% 
  mutate(NUTS_ID = case_when(regionname == "Arges" ~ "RO311",
                             regionname == "Bacau" ~ "RO211",
                             regionname == "Bistrita-Nasaud" ~ "RO112",
                             regionname == "Botosani" ~ "RO212",
                             regionname == "Brasov" ~ "RO122",
                             regionname == "Braila" ~ "RO221",
                             regionname == "Buzau" ~ "RO222",
                             regionname == "Caras-Severin" ~ "RO422",
                             regionname == "Calarasi" ~ "RO312",
                             regionname == "Constanta" ~ "RO223",
                             regionname == "Dambovita" ~ "RO313",
                             regionname == "Galati" ~ "RO224",
                             regionname == "Ialomita" ~ "RO315",
                             regionname == "Iasi" ~ "RO213",
                             regionname == "Maramures" ~ "RO114",
                             regionname == "Mehedinti" ~ "RO413",
                             regionname == "Mures" ~ "RO125",
                             regionname == "Neamt" ~ "RO214",
                             regionname == "Salaj" ~ "RO116",
                             regionname == "Timis" ~ "RO424",
                             regionname == "Valcea" ~ "RO415",
                             regionname == "Bucharest Municipality" ~ "RO321",
                             T ~ NUTS_ID))

ro_emigration_nuts <- ro_emigration %>% 
  select(regionname, NUTS_ID)

ro_emigration <- ro_emigration %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "emigration") %>% 
  mutate(year = gsub("Year ", "", year)) %>% 
  mutate(year = as.numeric(year),
         emigration = as.numeric(emigration))


## Population -------------------------------------------------------------

# Source: http://statistici.insse.ro:8077/tempo-online/#/pages/tables/insse-table (retrieved 13 November 2023)
# Original file must be resaved as from XLS to XLSX
raw_xl <- read_excel(here("data", "02_external_emigration", "ro", "TEMPO_POP107A_1_10_2023.xlsx"), skip = 2)

ro_population <- raw_xl %>% 
  select(-c(`...1`, `...2`, `...3`)) %>% 
  drop_na(`...4`) %>% 
  rename(regionname = `...4`) %>% 
  left_join(ro_emigration_nuts, by = "regionname") %>% 
  drop_na(NUTS_ID) %>%
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population") %>% 
  mutate(year = gsub("Year ", "", year)) %>% 
  mutate(year = as.numeric(year),
         population = as.numeric(population))

save(ro_population, file = here("data", "02_external_emigration", "ro", "ro_population.Rda"))
  

## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

ro <- ro_emigration %>%
  left_join(ro_population, by = c("NUTS_ID", "year")) %>% 
  mutate(emigration_yearly_per_1000 = (emigration/population) * 1000)# %>% 
  #select(NUTS_ID, year, emigration_yearly_per_1000)


## Calculate emigration between elections --------------------------------

# Use sum of emigration in a region between elections
# E.g. 2001, 2002, 2003 and 2004 for election in 2005
# Use average of population in a region between elections
# Calculate emigration per 1000 with this

# Create an empty dataframe to store the results
sum_results <- data.frame()
avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(ro_election_years) - 1)) {
  start_year <- ro_election_years[i]
  end_year <- ro_election_years[i + 1]
  
  # Filter and summarize emigration
  sum_data <- ro %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(sum_emigration = sum(emigration, na.rm = T))
  
  # Filter and average emigration
  avg_data <- ro %>%
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

ro <- ro %>% 
  left_join(election_emigration, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Export ------------------------------

save(ro, file = here("data", "02_external_emigration", "ro", "ro.Rda"))
