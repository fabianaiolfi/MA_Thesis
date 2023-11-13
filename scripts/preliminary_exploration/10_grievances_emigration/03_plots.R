
# Plot Setup -------------------------------------------------------------------

# Define ggplot parameters
plot_scale <- 3
plot_width <- 500
plot_height <- 1000
plot_units <-  "px"
plot_dpi <-  300
plot_bg <-  "white"
save_here <- here("documentation", "happiness", "ess_")

# Plots -------------------------------------------------------------------

ggplot(ess_eda_2013, aes(avg_migration, weighted_avg)) +            
  geom_point(size = 1.5) +
  geom_vline(xintercept = 0, size = 0.5, linetype = "dotted") +
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth",
              se = F) +
  ggtitle("ESS 6 (2013)") +
  xlab("Net Migration in NUTS3 Region") +
  ylab("Happiness") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

ggsave(
  paste0(save_here, "6_2013.png"),
  last_plot(),
  scale = plot_scale,
  width = plot_width,
  height = plot_height,
  dpi = plot_dpi,
  units = plot_units,
  bg = plot_bg)


ggplot(ess_eda_2017, aes(avg_migration, weighted_avg)) +            
  geom_point(size = 1.5) +
  geom_vline(xintercept = 0, size = 0.5, linetype = "dotted") +
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth",
              se = F) +
  ggtitle("ESS 8 (2017)") +
  xlab("Net Migration in NUTS3 Region") +
  ylab(" ") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

ggsave(
  paste0(save_here, "8_2017.png"),
  last_plot(),
  scale = plot_scale,
  width = plot_width,
  height = plot_height,
  dpi = plot_dpi,
  units = plot_units,
  bg = plot_bg)


ggplot(ess_eda_2019, aes(avg_migration, weighted_avg)) +            
  geom_point(size = 1.5) +
  geom_vline(xintercept = 0, size = 0.5, linetype = "dotted") +
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth",
              se = F) +
  ggtitle("ESS 9 (2019)") +
  xlab("Net Migration in NUTS3 Region") +
  ylab(" ") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

ggsave(
  paste0(save_here, "9_2019.png"),
  last_plot(),
  scale = plot_scale,
  width = plot_width,
  height = plot_height,
  dpi = plot_dpi,
  units = plot_units,
  bg = plot_bg)


ggplot(ess_eda_2021, aes(avg_migration, weighted_avg)) +            
  geom_point(size = 1.5) +
  geom_vline(xintercept = 0, size = 0.5, linetype = "dotted") +
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth",
              se = F) +
  ggtitle("ESS 10 (2021)") +
  xlab("Net Migration in NUTS3 Region") +
  ylab(" ") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

ggsave(
  paste0(save_here, "10_2021.png"),
  last_plot(),
  scale = plot_scale,
  width = plot_width,
  height = plot_height,
  dpi = plot_dpi,
  units = plot_units,
  bg = plot_bg)
