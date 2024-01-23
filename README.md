# MA Thesis

## Research Proposal

**To Do**
- [ ] Controlling for volatility
  - [ ] Is Pedersen Index correctly used?
  - [ ] Describe in theory and explain in methods
- [ ] Create summary stats of data used: Elections, etc.
- [ ] Address decrease in number of Romanian schools in early 2000s
- [ ] Maybe use a table to explain how I calculate average change in ratio or emigration, by using a simple example
- [ ] Check for contractions and remove them
- [ ] number of decimal places in regression tables
- [ ] place group subtitle to group control variables in regression table?
- [ ] replace p-values with standard errors in regression tables
- [ ] Reference Github repo
- [ ] Reference help from LLMs
- [ ] Clean up references
- [ ] Add subtitle/proper thesis title (to abstract page?)
- [ ] Add appendix
  - [ ] Graphs from `240111_data_analysis`
  - [ ] Complete regression tables

----

- [ ] Preliminary Explorations
	- [x] NUTS3 emigration map
	- [x] Model emigration and vote switching
	- [x] International emigration rate before and after EU accession
	- [x] Measure grievances through ESS5 and ESS9: How happy are you? → correlation between happiness and emigration → are people from emigration-high regions generally unhappier? → 10_grievances_emigration
	- [ ] Is there demographic change in emigration hit regions? Are there less younger and more older people? Does this correlate with less schools and less hospitals?
	- [ ] Grievances and vote switching: Is there a correlation between the two in general, and more so in the actual regions that are hit by emigration? → might be difficult because EES does not ask about happiness → combine EES and ESS?; or maybe Q20 “And over the next 12 months, how do you think the general economic situation in Ireland will be?”

## Preliminary Explorations
- 05_incumbent_vote_share: Is there a correlation between NUTS3 international emigration and vote share of the incumbent party?
- 06_age_demographics: Create plot showing below 15y/o and over 65y/o population number in CEE
- 07_schools_emigration: Model correlation between number of schools and net migration
- 08_hospital_beds_emigration: Model correlation between number of hospital beds and net migration
- 09_third_places_emigration: Model correlation between number of third places and net migration
- 10_grievances_emigration: Model correlation between happiness and net migration

## Scripts
- 01_anti_incumbent_vote: Calculate anti-incumbent vote
- 02_external_emigration: Model anti-incumbent vote and emigration rate
  - Continue here: `03_modelling.R`
  - See plot `03_modelling_temp_bg_model.png`
  - Continue exploring different parties and how their vote share changes together with average emigration
  - Collect data from further countries
  