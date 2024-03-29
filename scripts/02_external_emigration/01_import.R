
# Import Voting Data -------------------------------------------------------------

load(here("data", "01_anti_incumbent_vote", "ned_v_dem_cee.Rda"))


# Import Migration Data -------------------------------------------------------------

# Population numbers
load(here("data", "02_external_emigration", "nuts3_population.Rda"))


## Bulgaria -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "bg.R"))
load(here("data", "02_external_emigration", "bg", "bg.Rda"))


## Croatia -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "hr.R"))
load(here("data", "02_external_emigration", "hr", "hr.Rda"))


## Czechia / Czech Republic -------------------------------------------------------------

# Not the right data available
# https://vdb.czso.cz/vdbvo2/faces/en/index.jsf?page=vystup-objekt-vyhledavani&vyhltext=migration&bkvt=bWlncmF0aW9u&katalog=all&pvo=DEM11D (retrieved 7 November 2023)
# Variable "Out-migrants" definition: "… Depending on the given type of migration or the territory for which the data is published, it may be internal migration, foreign migration or a combination of both types…" (via Google Translate)


## Estonia -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "ee.R"))
load(here("data", "02_external_emigration", "ee", "ee.Rda"))


## Hungary -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "hu.R"))
load(here("data", "02_external_emigration", "hu", "hu.Rda"))


## Latvia -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "lv.R"))
load(here("data", "02_external_emigration", "lv", "lv.Rda"))


## Lithuania -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "lt.R"))
load(here("data", "02_external_emigration", "lt", "lt.Rda"))


## Poland -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "pl.R"))
load(here("data", "02_external_emigration", "pl", "pl.Rda"))


## Romania -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "ro.R"))
load(here("data", "02_external_emigration", "ro", "ro.Rda"))


## Slovakia -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "sk.R"))
load(here("data", "02_external_emigration", "sk", "sk.Rda"))


## Slovenia -------------------------------------------------------------

# source(here("scripts", "02_external_emigration", "01_import_preprocess", "si.R"))
load(here("data", "02_external_emigration", "si", "si.Rda"))


## Merge Countries into one dataframe -------------------------------------------------------------

cee_crude_emigration <- bind_rows(bg, ee, hr, hu, lt, lv, pl, ro, si, sk)

cee_crude_emigration <- cee_crude_emigration %>% 
  mutate(country = substr(NUTS_ID, 1, 2))

save(cee_crude_emigration, file = here("data", "02_external_emigration", "cee_crude_emigration.Rda"))
