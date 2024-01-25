
# Universal Variables -------------------------------------------------------------

cee <- c("BG", "HR", "CZ", "EE", "HU", "LV", "LT", "PL", "RO", "SK", "SI")
pattern <- paste(cee, collapse = "|")


# Data Import and Preprocessing -------------------------------------------------------------

demo_r_pjanaggr3_linear <- read.csv(here("data", "demo_r_pjanaggr3_linear.csv"))
# save(demo_r_pjanaggr3_linear, file = here("data", "demo_r_pjanaggr3_linear.rda"))

# NUTS3
# df <- df %>% 
#   select(sex, age, geo, TIME_PERIOD, OBS_VALUE) %>% 
#   dplyr::filter(str_detect(geo, pattern)) %>% 
#   dplyr::filter(sex == "T") %>% 
#   select(-sex) %>% 
#   dplyr::filter(str_length(geo) == 5)

# NUTS0
demo_r_pjanaggr3_linear <- demo_r_pjanaggr3_linear %>% 
  select(sex, age, geo, TIME_PERIOD, OBS_VALUE) %>% 
  dplyr::filter(geo %in% cee) %>% 
  dplyr::filter(sex == "T") %>% 
  select(-sex)

# Less than 15 years [Y_LT15]
df_young <- demo_r_pjanaggr3_linear %>% 
  dplyr::filter(age == "Y_LT15")

# 65 years or over [Y_GE65]
df_old <- demo_r_pjanaggr3_linear %>% 
  dplyr::filter(age == "Y_GE65")