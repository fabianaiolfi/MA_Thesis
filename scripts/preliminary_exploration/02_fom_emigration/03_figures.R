
# Figures -------------------------------------------------------------

net_int_migration %>% 
  dplyr::filter(Country == "Croatia") %>% 
  drop_na(Emigration) %>% 
  ggplot() +
  geom_col(aes(y = Emigration, x = Year)) +
  geom_step(aes(x = Year, y = FoM_Countries*1200), size = 1) +
  theme_minimal()

net_int_migration %>% 
  dplyr::filter(Country == "Poland") %>% 
  ggplot() +
  geom_col(aes(y = Emigration, x = Year)) +
  geom_step(aes(x = Year, y = FoM_Countries*1000), size = 1) +
  theme_minimal()

net_int_migration %>% 
  dplyr::filter(Country == "Romania") %>% 
  dplyr::filter(Year >= 1997) %>% 
  ggplot() +
  geom_col(aes(y = Emigration, x = Year)) +
  geom_step(aes(x = Year, y = FoM_Countries*1000), size = 1) +
  theme_minimal()
