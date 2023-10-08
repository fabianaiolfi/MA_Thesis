
# Universal Variables -------------------------------------------------------------

#cee <- c("BG", "HR", "CZ", "EE", "HU", "LV", "LT", "PL", "RO", "SK", "SI")
pattern <- paste(cee, collapse = "|")


# Data Import and Preprocessing -------------------------------------------------------------

df <- read.csv(here("data", "demo_r_pjanaggr3_linear.csv"))

# NUTS3
# df <- df %>% 
#   select(sex, age, geo, TIME_PERIOD, OBS_VALUE) %>% 
#   dplyr::filter(str_detect(geo, pattern)) %>% 
#   dplyr::filter(sex == "T") %>% 
#   select(-sex) %>% 
#   dplyr::filter(str_length(geo) == 5)

# NUTS0
df <- df %>% 
  select(sex, age, geo, TIME_PERIOD, OBS_VALUE) %>% 
  dplyr::filter(geo %in% cee) %>% 
  dplyr::filter(sex == "T") %>% 
  select(-sex)

# Less than 15 years [Y_LT15]
df_young <- df %>% 
  dplyr::filter(age == "Y_LT15")

# 65 years or over [Y_GE65]
df_old <- df %>% 
  dplyr::filter(age == "Y_GE65")