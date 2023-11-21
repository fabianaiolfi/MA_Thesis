
# CEE NUTS0 --------------------------------------

cee <- c("BG", "HR", "CZ", "EE", "HU", "LV", "LT", "PL", "RO", "SK", "SI")
cee_names <- c("Bulgaria", "Croatia", "Czech Republic", "Czechia", "Estonia", "Hungary", "Latvia", "Lithuania", "Poland", "Romania", "Slovakia", "Slovenia")


# Croatian NUTS3 Recoding --------------------------------------

# https://ec.europa.eu/eurostat/web/nuts/background
# https://ec.europa.eu/eurostat/documents/345175/629341/NUTS2021.xlsx
# /Data/NUTS2021.xlsx
hr_nuts_recoding <- read_csv(here("data", "HR_NUTS_Recoding.csv"))


# NUTS3 IDs and Names --------------------------------------

cee_nuts3 <- eurostat::eurostat_geodata_60_2016 %>% 
  select(NUTS_ID, NAME_LATN, NUTS_NAME) %>% 
  # Filter for CEE
  dplyr::filter(str_detect(NUTS_ID, paste0("^", cee, collapse = "|"))) %>% 
  # Filter for NUTS3
  dplyr::filter(str_length(NUTS_ID) == 5)
  
cee_nuts3$geometry <- NULL


# NUTS2 IDs and Names --------------------------------------

cee_nuts2 <- eurostat::eurostat_geodata_60_2016 %>% 
  select(NUTS_ID, NAME_LATN, NUTS_NAME) %>% 
  # Filter for CEE
  dplyr::filter(str_detect(NUTS_ID, paste0("^", cee, collapse = "|"))) %>% 
  # Filter for NUTS2
  dplyr::filter(str_length(NUTS_ID) == 4)

cee_nuts2$geometry <- NULL


# Capitalize letter after space -----------------------------
# Used for pl.R scripts

capitalizeAfterSpace <- function(s) {
  # Splitting the string into characters
  chars <- unlist(strsplit(s, ""))
  
  # Lowercasing all characters first
  chars <- tolower(chars)
  
  # Capitalizing the first character
  chars[1] <- toupper(chars[1])
  
  # Finding spaces and capitalizing the following character
  for (i in 1:(length(chars) - 1)) {
    if (chars[i] == " " && i < length(chars)) {
      chars[i + 1] <- toupper(chars[i + 1])
    }
  }
  
  # Collapsing the characters back into a single string
  paste0(chars, collapse = "")
}