# Loads in the Prem matrices for Germany, taken from the 2015 paper.

prem_home <- readxl::read_xlsx("data-raw/prem/MUestimates_home_1.xlsx", sheet = "Germany") %>%
  as.matrix() %>%
  t()

prem_school <- readxl::read_xlsx("data-raw/prem/MUestimates_school_1.xlsx", sheet = "Germany") %>%
  as.matrix() %>%
  t()

prem_work <- readxl::read_xlsx("data-raw/prem/MUestimates_work_1.xlsx", sheet = "Germany") %>%
  as.matrix() %>%
  t()

prem_other <- readxl::read_xlsx("data-raw/prem/MUestimates_other_locations_1.xlsx", sheet = "Germany") %>%
  as.matrix() %>%
  t()

prem_germany_contact_matrices <- list(
  "home" = prem_home,
  "work" = prem_work,
  "school" = prem_school,
  "other" = prem_other,
  "all" = prem_home + prem_work + prem_school + prem_other
)

usethis::use_data(prem_germany_contact_matrices, overwrite = TRUE)
