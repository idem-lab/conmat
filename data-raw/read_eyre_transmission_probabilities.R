# digitise setting- and age-specific transmission probability matrices
library(dplyr)
library(tidyr)
library(png)
library(fields)
source("data-raw/digitise_eyre_matrix.R")
source("data-raw/euclidean_join.R")
source("data-raw/get_age_group_lookup.R")
eyre_transmission_probabilities <- bind_rows(
  household = digitise_eyre_matrix(
    matrix_file = "data-raw/eyre_transmission_household.png"
  ),
  household_visitor = digitise_eyre_matrix(
    matrix_file = "data-raw/eyre_transmission_household_visitor.png"
  ),
  work_education = digitise_eyre_matrix(
    matrix_file = "data-raw/eyre_transmission_work_education.png"
  ),
  events_activities = digitise_eyre_matrix(
    matrix_file = "data-raw/eyre_transmission_events_activities.png"
  ),
  .id = "setting"
)

# save version with 5y lookup
age_lookup <- get_age_group_lookup(
  age_breaks = c(seq(0, 80, by = 5), Inf)
)

eyre_transmission_probabilities_with_5y <- eyre_transmission_probabilities %>%
  left_join(
    rename(
      age_lookup,
      case_age = age,
      case_age_5y = age_group
    ),
    by = "case_age"
  ) %>%
  left_join(
    rename(
      age_lookup,
      contact_age = age,
      contact_age_5y = age_group
    ),
    by = "contact_age"
  ) %>%
  relocate(
    case_age_5y,
    contact_age_5y,
    .before = probability
  )

eyre_transmission_probabilities <- eyre_transmission_probabilities_with_5y

minty::write_csv(
  x = eyre_transmission_probabilities,
  file = "data-raw/eyre_transmission_probabilities.csv"
)

zip::zip(
  zipfile = "data-raw/eyre_transmission_probabilities.csv.gz",
  files = "data-raw/eyre_transmission_probabilities.csv"
)

thing <- minty::read_csv("data-raw/eyre_transmission_probabilities.csv.gz")

fs::file_delete("data-raw/eyre_transmission_probabilities.csv")

use_data(eyre_transmission_probabilities, compress = "xz", overwrite = TRUE)
