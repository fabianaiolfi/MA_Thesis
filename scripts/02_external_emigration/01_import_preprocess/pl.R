
# Poland -------------------------------------------------------------


## Emigration (NUTS3) -------------------------------------------------------------

# # Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 10 November 2023)
# raw_csv <- read_delim(here("data", "02_external_emigration", "pl", "LUDN_1350_CTAB_20231110071448.csv"),
#                       delim = ";")
#  
# pl_emigration <- raw_csv %>%
#   select(-c(Code, `...31`)) %>% 
#   rename(regionname = Name)
# 
# # Rename columns to year
# year_names <- as.character(1995:2022)
# current_names <- colnames(pl_emigration) # Getting the current column names
# current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
# colnames(pl_emigration) <- current_names # Assigning the new names back to the dataframe
# 
# # Capitalize letter after space
# capitalizeAfterSpace <- function(s) {
#   # Splitting the string into characters
#   chars <- unlist(strsplit(s, ""))
#   
#   # Lowercasing all characters first
#   chars <- tolower(chars)
#   
#   # Capitalizing the first character
#   chars[1] <- toupper(chars[1])
#   
#   # Finding spaces and capitalizing the following character
#   for (i in 1:(length(chars) - 1)) {
#     if (chars[i] == " " && i < length(chars)) {
#       chars[i + 1] <- toupper(chars[i + 1])
#     }
#   }
#   
#   # Collapsing the characters back into a single string
#   paste0(chars, collapse = "")
# }
# 
# # More preprocessing
# pl_emigration <- pl_emigration %>% 
#   dplyr::filter(str_detect(regionname, "SUBREGION")) %>% 
#   mutate(regionname = gsub("SUBREGION ", "", regionname)) %>% 
#   mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>% 
#   mutate(regionname = gsub("City Of", "Miasto", regionname)) %>% 
#   mutate(regionname = gsub("Capital ", "", regionname)) %>% 
#   mutate(regionname = gsub("Wschodni", "wschodni", regionname)) %>% 
#   mutate(regionname = gsub("Zachodni", "zachodni", regionname)) %>% 
#   left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
#   select(-regionname) %>% 
#   pivot_longer(cols = -NUTS_ID,
#                names_to = "year",
#                values_to = "emigration") %>% 
#   mutate(year = as.numeric(year)) %>% 
#   mutate(emigration = case_when(emigration == 0 & year == 2015 ~ NA,
#                                 T ~ emigration))


## Emigration (NUTS2) -------------------------------------------------------------

# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 17 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "pl", "LUDN_1350_CTAB_20231117225445.csv"),
                      delim = ";")

pl_emigration <- raw_csv %>%
  select(-c(Code, `...31`)) %>% 
  rename(regionname = Name)

# Rename columns to year
year_names <- as.character(1995:2022)
current_names <- colnames(pl_emigration) # Getting the current column names
current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_emigration) <- current_names # Assigning the new names back to the dataframe

# Combine Warszawski wschodni and Warszawski zachodni
# Assuming you have a dataframe 'df' and you know the indices of the rows to add
index1 <- which(pl_emigration$regionname == "SUBREGION WARSZAWSKI WSCHODNI") # Replace with the actual region name or condition
index2 <- which(pl_emigration$regionname == "SUBREGION WARSZAWSKI ZACHODNI") # Replace with the actual region name or condition
numeric_sum <- pl_emigration[index1, sapply(pl_emigration, is.numeric)] + pl_emigration[index2, sapply(pl_emigration, is.numeric)] # Sum numeric columns
new_row <- c(regionname = "Warszawski stołeczny", numeric_sum) # Combine into a new row
pl_emigration <- rbind(pl_emigration, new_row) # Add as a new row at the end of the dataframe
pl_emigration <- pl_emigration[-c(index1, index2), ]
rm(new_row, index1, index2, numeric_sum)

# More preprocessing
pl_emigration <- pl_emigration %>% 
  mutate(regionname = gsub("REGION ", "", regionname)) %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>% 
  left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Mazowiecki Regionalny" ~ "PL92",
                             regionname == "Warszawski Stołeczny" ~ "PL91",
                             T ~ NUTS_ID)) %>% 
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "emigration") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(emigration = case_when(emigration == 0 & year == 2015 ~ NA,
                                T ~ emigration))


## Population (NUTS3) -------------------------------------------------------------

# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 10 November 2023)
# raw_csv <- read_delim(here("data", "02_external_emigration", "pl", "LUDN_2425_CTAB_20231110072421.csv"),
#                       delim = ";")
# 
# pl_population <- raw_csv %>% 
#   select(-c(Code, `...31`)) %>% 
#   rename(regionname = Name)
# 
# # Rename columns to year
# year_names <- as.character(1995:2022)
# current_names <- colnames(pl_population) # Getting the current column names
# current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
# colnames(pl_population) <- current_names # Assigning the new names back to the dataframe
# 
# # More preprocessing
# pl_population <- pl_population %>% 
#   dplyr::filter(str_detect(regionname, "SUBREGION")) %>% 
#   mutate(regionname = gsub("SUBREGION ", "", regionname)) %>% 
#   mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>% 
#   mutate(regionname = gsub("City Of", "Miasto", regionname)) %>% 
#   mutate(regionname = gsub("Capital ", "", regionname)) %>% 
#   mutate(regionname = gsub("Wschodni", "wschodni", regionname)) %>% 
#   mutate(regionname = gsub("Zachodni", "zachodni", regionname)) %>% 
#   left_join(select(cee_nuts3, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
#   select(-regionname) %>% 
#   pivot_longer(cols = -NUTS_ID,
#                names_to = "year",
#                values_to = "population") %>% 
#   mutate(year = as.numeric(year)) %>% 
#   mutate(population = population * 1000) # Original CSV population in thousand persons


## Population (NUTS2) -------------------------------------------------------------

# Source: https://bdl.stat.gov.pl/bdl/dane/podgrup/tablica (retrieved 17 November 2023)
raw_csv <- read_delim(here("data", "02_external_emigration", "pl", "LUDN_2425_CTAB_20231117224214.csv"),
                      delim = ";")

pl_population <- raw_csv %>% 
  select(-c(Code, `...31`)) %>% 
  rename(regionname = Name)

# Rename columns to year
year_names <- as.character(1995:2022)
current_names <- colnames(pl_population) # Getting the current column names
current_names[2:29] <- year_names # Replacing the names of columns 2 through 29
colnames(pl_population) <- current_names # Assigning the new names back to the dataframe

# Combine Warszawski wschodni and Warszawski zachodni
# Assuming you have a dataframe 'df' and you know the indices of the rows to add
index1 <- which(pl_population$regionname == "SUBREGION WARSZAWSKI WSCHODNI") # Replace with the actual region name or condition
index2 <- which(pl_population$regionname == "SUBREGION WARSZAWSKI ZACHODNI") # Replace with the actual region name or condition
numeric_sum <- pl_population[index1, sapply(pl_population, is.numeric)] + pl_population[index2, sapply(pl_population, is.numeric)] # Sum numeric columns
new_row <- c(regionname = "Warszawski stołeczny", numeric_sum) # Combine into a new row
pl_population <- rbind(pl_population, new_row) # Add as a new row at the end of the dataframe
pl_population <- pl_population[-c(index1, index2), ]
rm(new_row, index1, index2, numeric_sum)

# More preprocessing
pl_population <- pl_population %>% 
  mutate(regionname = gsub("SUBREGION ", "", regionname)) %>% 
  mutate(regionname = gsub("REGION ", "", regionname)) %>% 
  mutate(regionname = sapply(regionname, capitalizeAfterSpace)) %>% 
  left_join(select(cee_nuts2, NUTS_ID, NAME_LATN), by = c("regionname" = "NAME_LATN")) %>% 
  mutate(NUTS_ID = case_when(regionname == "Mazowiecki Regionalny" ~ "PL92",
                             regionname == "Warszawski Stołeczny" ~ "PL91",
                             T ~ NUTS_ID)) %>%
  select(-regionname) %>% 
  pivot_longer(cols = -NUTS_ID,
               names_to = "year",
               values_to = "population") %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(population = population * 1000) # Original CSV population in thousand persons

save(pl_population, file = here("data", "02_external_emigration", "pl", "pl_population.Rda"))


## Calculate yearly emigration per 1000 --------------------------------

# Use same calculation of emigration as Eurostat: https://ec.europa.eu/eurostat/cache/metadata/en/demo_r_gind3_esms.htm

pl <- pl_emigration %>%
  left_join(pl_population, by = c("NUTS_ID", "year")) %>% 
  mutate(emigration_yearly_per_1000 = (emigration/population) * 1000)


## Calculate emigration between elections --------------------------------

# Use sum of emigration in a region between elections
# E.g. 2001, 2002, 2003 and 2004 for election in 2005
# Use average of population in a region between elections
# Calculate emigration per 1000 with this

# Create an empty dataframe to store the results
sum_results <- data.frame()
avg_results <- data.frame()

# Loop over the election years, excluding the last one
for (i in 1:(length(pl_election_years) - 1)) {
  start_year <- pl_election_years[i]
  end_year <- pl_election_years[i + 1]
  
  # Filter and summarize emigration
  sum_data <- pl %>%
    dplyr::filter(year >= start_year & year < end_year) %>%
    group_by(NUTS_ID) %>%
    summarize(sum_emigration = sum(emigration, na.rm = T))
  
  # Filter and average emigration
  avg_data <- pl %>%
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

pl <- pl %>% 
  left_join(election_emigration, by = c("NUTS_ID" = "NUTS_ID", "year" = "election_year"))


## Convert NUTS3 to NUTS2 --------------------------------

# ned_v_dem_cee only contains NUTS2 for Poland
# Adjust accordingly: Average NUTS3 crude emigration into NUTS2
# pl <- pl %>%
#   mutate(NUTS_ID = str_sub(NUTS_ID, 1, -2)) %>% 
#   group_by(NUTS_ID, year) %>% 
#   summarise(emigration_yearly_per_1000 = mean(emigration_yearly_per_1000, na.rm = T)) %>% 
#   mutate(emigration_yearly_per_1000 = gsub("NaN", NA, emigration_yearly_per_1000)) %>% 
#   mutate(emigration_yearly_per_1000 = as.numeric(emigration_yearly_per_1000))

# NUTS3 electoral data could be retrieved from https://wybory.gov.pl/sejmsenat2023/en/sejm/wynik/pl,
# but only with a massive effort


## Export ------------------------------

save(pl, file = here("data", "02_external_emigration", "pl", "pl.Rda"))
