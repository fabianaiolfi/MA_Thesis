
# Chow test ------------------------------------------------------------------
# https://en.wikipedia.org/wiki/Chow_test

range_year <- 10

# Prepare Data
migr_croatia <- net_int_migration %>% 
  dplyr::filter(Country == "Croatia") %>% 
  dplyr::filter(Year >= EU_Accession - range_year & Year <= EU_Accession + range_year) %>% 
  drop_na(Emigration)

migr_czech <- net_int_migration %>% 
  dplyr::filter(Country == "Czech Republic") %>% 
  dplyr::filter(Year >= EU_Accession - range_year & Year <= EU_Accession + range_year) %>% 
  drop_na(Emigration)

migr_poland <- net_int_migration %>% 
  dplyr::filter(Country == "Poland") %>% 
  dplyr::filter(Year >= EU_Accession - range_year & Year <= EU_Accession + range_year) %>% 
  drop_na(Emigration)

migr_romania <- net_int_migration %>% 
  dplyr::filter(Country == "Romania") %>% 
  dplyr::filter(Year >= EU_Accession - range_year & Year <= EU_Accession + range_year) %>% 
  drop_na(Emigration)

migr_slovenia <- net_int_migration %>% 
  dplyr::filter(Country == "Slovenia") %>% 
  dplyr::filter(Year >= EU_Accession - range_year & Year <= EU_Accession + range_year) %>% 
  drop_na(Emigration)

# Perform Chow test
chow_romania <- sctest(migr_romania$Emigration ~ migr_romania$Year,
       type = "Chow",
       point = which(migr_romania$Year == migr_romania$EU_Accession) + 1)
print(chow_romania)

chow_poland <- sctest(migr_poland$Emigration ~ migr_poland$Year,
       type = "Chow",
       point = which(migr_poland$Year == migr_poland$EU_Accession) + 1)
print(chow_poland)

chow_croatia <- sctest(migr_croatia$Emigration ~ migr_croatia$Year,
       type = "Chow",
       point = which(migr_croatia$Year == migr_croatia$EU_Accession) + 1)
print(chow_croatia)

chow_czech <- sctest(migr_czech$Emigration ~ migr_czech$Year,
       type = "Chow",
       point = which(migr_czech$Year == migr_czech$EU_Accession) + 1)
print(chow_czech)

chow_slovenia <- sctest(migr_slovenia$Emigration ~ migr_slovenia$Year,
       type = "Chow",
       point = which(migr_slovenia$Year == migr_slovenia$EU_Accession) + 1)
print(chow_slovenia)
