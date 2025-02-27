# Loads in the Prem matrices for Germany, taken from the 2021 paper.

load("data-raw/prem/contact_home.rdata")
load("data-raw/prem/contact_work.rdata")
load("data-raw/prem/contact_school.rdata")
load("data-raw/prem/contact_others.rdata")
load("data-raw/prem/contact_all.rdata")

# ISO3 code for Germany is DEU

prem_home <- contact_home[["DEU"]] %>%
  t()

prem_work <- contact_work[["DEU"]] %>%
  t()

prem_school <- contact_school[["DEU"]] %>%
  t()

prem_other <- contact_others[["DEU"]] %>%
  t()

prem_all <- contact_all[["DEU"]] %>%
  t()

prem_germany_contact_matrices <- list(
  "home" = prem_home,
  "work" = prem_work,
  "school" = prem_school,
  "other" = prem_other,
  "all" = prem_all
)

usethis::use_data(prem_germany_contact_matrices, overwrite = TRUE)
