
# Plots -------------------------------------------------------------------

df_young_plot <- df_young %>% 
  dplyr::filter(TIME_PERIOD <= 2019)

ggplot(df_young_plot) +
  geom_line(aes(x = TIME_PERIOD, y = OBS_VALUE)) +
  facet_wrap(~ geo, scales = "free") +
  theme_minimal()

df_old_plot <- df_old %>% 
  dplyr::filter(TIME_PERIOD <= 2019)

ggplot(df_old_plot) +
  geom_line(aes(x = TIME_PERIOD, y = OBS_VALUE)) +
  facet_wrap(~ geo, scales = "free") +
  theme_minimal()


df_plot <- df %>% 
  dplyr::filter(TIME_PERIOD <= 2019) %>% 
  dplyr::filter(age == "Y_LT15" | age == "Y_GE65") %>% 
  mutate(age = case_when(age == "Y_LT15" ~ "Less than 15 years",
                         age == "Y_GE65" ~ "65 years or over")) %>% 
  rename(Year = TIME_PERIOD,
         `Population Size` = OBS_VALUE,
         Age = age)

ggplot(df_plot) +
  geom_line(aes(x = Year, y = `Population Size`, color = Age)) +
  facet_wrap(~ geo, scales = "free_y") +
  scale_y_continuous(labels = comma) +
  theme_minimal()
