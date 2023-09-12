
# Modelling ---------------------------------------------------------------

# Setup model dataframe
model_df <- ees_cee_nuts3 %>%
  group_by(region_NUTS3) %>%
  mutate(
    total = n(),
    switcher_count = sum(switcher, na.rm = TRUE),
    switcher_share = switcher_count / total * 100
  ) %>%
  ungroup() %>%
  select(-total, -switcher_count, -switcher) %>% 
  distinct(region_NUTS3, .keep_all = T)

# Plot model dataframe
ggplot(model_df, aes(avg_migr, switcher_share)) +
  geom_point() +
  geom_vline(xintercept = 0, linetype="dashed", color = "black", linewidth = .25) +
  annotate("text", x = -0.5, y = 42, label = "← More Emigration", hjust = 1) +
  annotate("text", x = 0.5, y = 42, label = "More Immigration →", hjust = 0) +
  stat_smooth(method = "lm",
              formula = y ~ x,
              geom = "smooth") +
  xlim(-16, 10) +
  ylim(0, 42) +
  ylab("% Switchers in NUTS3 Region (2019)") +
  xlab("Average Migration between 2009–2019 (% of Population)") +
  #ggtitle("Migration and Vote Switching in Select NUTS3 Regions") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())

model <- lm(switcher_share ~ avg_migr, model_df)
summary(model)

# 2015 - 2019
# Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  25.3823     1.1341   22.38   <2e-16 ***
#   avg_migr     -0.3103     0.1430   -2.17   0.0378 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 5.955 on 31 degrees of freedom
# Multiple R-squared:  0.1319,	Adjusted R-squared:  0.1039 
# F-statistic: 4.709 on 1 and 31 DF,  p-value: 0.0378

# 2009 - 2019
# Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  24.7970     1.2446  19.924   <2e-16 ***
#   avg_migr     -0.3641     0.1606  -2.268   0.0305 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 5.919 on 31 degrees of freedom
# Multiple R-squared:  0.1423,	Adjusted R-squared:  0.1146 
# F-statistic: 5.144 on 1 and 31 DF,  p-value: 0.03045


