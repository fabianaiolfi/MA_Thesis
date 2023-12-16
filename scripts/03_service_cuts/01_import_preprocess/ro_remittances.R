
# Remittances --------------------------------

# Source: https://www.knomad.org/data/remittances (retrieved 27 November 2023)
raw_xlsx <- read_excel(here("data", "03_service_cuts", "pl", "remittance_inflows_brief_38_june_2023_3.xlsx"))

ro_remittances <- raw_xlsx %>% 
  dplyr::filter(`Remittance inflows (US$ million)` == "Romania") %>% 
  select(-`Remittance inflows (US$ million)`) %>% 
  pivot_longer(cols = everything(),
               names_to = "year",
               values_to = "remittances") %>% 
  mutate(year = as.numeric(year))


## Export ------------------------------

save(ro_remittances, file = here("data", "03_service_cuts", "ro", "ro_remittances.Rda"))
