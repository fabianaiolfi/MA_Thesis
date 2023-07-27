
# Preprocessing -------------------------------------------------------------

net_migr_nuts3_pp <- net_migr_nuts3 %>% 
  select(-c(`2022`)) %>% # Remove 2022 as it only contains NAs
  # Clean up column names
  rename(nuts3 = `GEO (Codes)`) %>% 
  rename(nuts3_name = `GEO (Labels)`) %>% 
  rename_with(~ ifelse(. %in% c("nuts3", "nuts3_name"), ., paste0("year_", .))) %>% 
  dplyr::filter(nuts3 != "") %>% # Remove empty rows
  dplyr::filter(nchar(nuts3) == 5) # Only keep NUTS3 regions


# Numeric to Factors -------------------------------------------------------------

# Define column names
year_cols <- paste0("year_", 2000:2021)

net_migr_nuts3_pp <- net_migr_nuts3_pp %>% 
  mutate_at(.vars = year_cols, .funs = list(fct = ~cut(
    .,
    breaks = c(-Inf, -20, -10, 0, 10, 20, Inf),
    labels = c("<20%", "-20-10%", "-10-0%", "0-10%", "10-20%", ">20%"),
    include.lowest = TRUE,
    right = FALSE,
    ordered_result = TRUE
  )))
