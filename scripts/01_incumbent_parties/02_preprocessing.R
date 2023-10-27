
# Preprocessing -----------------------------------------------------------

v_dem_cee <- v_dem %>% 
  dplyr::filter(country_name %in% cee_names) %>% 
  dplyr::filter(year >= 2000) %>% 
  select(year, country_name, v2paenname, pf_party_id, v2pashname, v2pagovsup) %>% 
  mutate(incumbent = case_when(v2pagovsup == 0 ~ T,
                               v2pagovsup == 1 ~ T,
                               v2pagovsup == 2 ~ T,
                               v2pagovsup == 3 ~ F,
                               v2pagovsup == 4 ~ NA))

v_dem_cee_incumbent_parties <- v_dem_cee %>% 
  dplyr::filter(incumbent == T) %>% 
  select(-incumbent)
