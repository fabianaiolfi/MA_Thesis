
# Setup -------------------------------------------------------------------

# Define ggplot parameters
plot_scale <- 3
plot_width <- 600
plot_height <- 1000
plot_units <- "px"
plot_dpi <-  300
plot_bg <-  "white"
save_here <- here("documentation")


# Plots -------------------------------------------------------------------

# Lagged Panel Data
df_plot <- as.data.frame(cz_third_places_emigration_pdata)

ggplot(df_plot, aes(net_migration_lag, OBS_VALUE)) +            
  geom_point(size = 1.5) +
  geom_vline(xintercept = 0, size = 0.5, linetype = "dotted") +
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth",
              se = F) +
  ylab("Number of Food and Beverage Service Locations in NUTS3 Region") +
  xlab("Net Migration in NUTS3 Region (Lag: 2 years)") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

ggsave(
  paste0(save_here, "/migration_third_places.png"),
  last_plot(),
  scale = plot_scale,
  width = plot_width,
  height = plot_height,
  dpi = plot_dpi,
  units = plot_units,
  bg = plot_bg)
