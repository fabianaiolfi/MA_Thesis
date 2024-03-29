
# Figures -------------------------------------------------------------

ggplot(net_int_migration, aes(y = Emigration, x = Year)) +
  geom_col(fill = "#666666") +
  facet_wrap(vars(Country), scales = "free_y", ncol = 2) +
  geom_vline(aes(xintercept = EU_Accession), color = "blue", size = 1) +
  ylab("Emigration") +
  # ggtitle("International Emigration and EU Accession") +
  theme_minimal()
