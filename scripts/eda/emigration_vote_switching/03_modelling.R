
# Modelling ---------------------------------------------------------------

model_df <- ees_cee_nuts3 %>%
  group_by(region_NUTS3) %>%
  mutate(
    total = n(),
    switcher_count = sum(switcher, na.rm = TRUE),
    switcher_share = switcher_count / total
  ) %>%
  ungroup() %>%
  select(-total, -switcher_count, -switcher) %>% 
  distinct(region_NUTS3, .keep_all = T)

plot(model_df$avg, model_df$switcher_share)

model <- lm(switcher_share ~ avg, model_df)
summary(model)