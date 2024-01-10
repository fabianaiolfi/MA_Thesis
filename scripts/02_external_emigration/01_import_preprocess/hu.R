
# Hungary -------------------------------------------------------------


## Emigration -------------------------------------------------------------

# Source: https://statinfo.ksh.hu/Statinfo/haViewer.jsp (retrieved 7 November 2023)
# Original CSV has ISO-8859-2 encoding, which must be converted to UTF8
raw_csv <- read_delim(here("data", "02_external_emigration", "hu", "Hungarian_citizens'_international_migration_utf8.csv"),
                      delim = ";",
                      skip = 6)

hu_emigration <- raw_csv %>% 
  select(-`...4`) %>% 
  rename(year = `Period of time`,
         regionname = `Geographic Area`,
         emigration = `Number of Hungarian citizens emigrating from Hungary (capita)`) %>% 
  mutate(year = gsub("\\. year", "", year)) %>% 
  fill(year) %>% # Fill rows with NAs with year from above row
  mutate(year = as.numeric(year),
         emigration = as.numeric(emigration)) %>% 
  dplyr::filter(regionname != "Pest region") %>% # Identical to "Pest vármegye"
  dplyr::filter(regionname != "Budapest region") %>% # Identical to "Budapest"
  mutate(regionname = gsub(" vármegye", "", regionname)) %>% 
  left_join(cee_nuts3, by = c("regionname" = "NAME_LATN")) %>% 
  select(-regionname) %>% 
  drop_na(NUTS_ID)


## Population -------------------------------------------------------------

# Source: https://www.ksh.hu/stadat_files/nep/en/nep0034.html (retrieved 16 November 2023)
# Original CSV has Windows 1252 encoding, which must be converted to UTF8
raw_csv <- read_delim(here("data", "02_external_emigration", "hu", "stadat-nep0034-22.1.2.1-hu_utf8.csv"),
                      skip = 1)
 
hu_population <- raw_csv %>%
  dplyr::filter(!row_number() %in% c(1:62)) %>% # Remove rows only containing population by gender
  dplyr::filter(grepl("capital|county", `Level of territorial units`)) %>% # Only keep rows contianing county or capital in "level" column
  select(-`Level of territorial units`) %>% 
  rename(regionname = `Name of territorial units`) %>% 
  left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Gyõr-Moson-Sopron" ~ "HU221",
                             regionname == "Csongrád-Csanád" ~ "HU333",
                             T ~ NUTS_ID)) %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population") %>% 
  mutate(population = gsub(" ", "", population)) %>% 
  mutate(year = as.numeric(year),
         population = as.numeric(population))


## Calculate crude emigration --------------------------------
# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

hu <- hu_emigration %>%
  left_join(hu_population, by = c("NUTS_ID", "year")) %>% 
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
for (i in 1:(length(hu_election_years) - 1)) {
  start_year <- hu_election_years[i]
  end_year <- hu_election_years[i + 1]
  
  # Filter and summarize emigration
  sum_data <- hu %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(sum_emigration = sum(emigration, na.rm = T))
  
  # Filter and average emigration
  avg_data <- hu %>%
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

hu <- hu %>% 
  left_join(election_emigration, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Export ------------------------------

save(hu, file = here("data", "02_external_emigration", "hu", "hu.Rda"))
