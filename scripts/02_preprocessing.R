
# Preprocessing -------------------------------------------------------------

net_migr_nuts3_pp <- net_migr_nuts3 %>% 
  select(-c(`2022`)) %>% # Remove 2022 as it only contains NAs
  # Clean up column names
  rename(nuts3 = `GEO (Codes)`) %>% 
  rename(nuts3_name = `GEO (Labels)`) %>% 
  rename_with(~ ifelse(. %in% c("nuts3", "nuts3_name"), ., paste0("year_", .))) %>% 
  dplyr::filter(nuts3 != "") %>% # Remove empty rows
  dplyr::filter(nchar(nuts3) == 5) # Only keep NUTS3 regions
