library(readr)
library(tidyverse)
library(here)
library(janitor)
employment_path <- here("data-raw/ABS_C16_G43_LGA_06092021163109650.csv")
abs_employment_raw <- read_csv(
  file = employment_path,
  name_repair = make_clean_names
) %>%
  select(
    age = age_2,
    sex,
    labour_force_status,
    state = state_2,
    lga_code = lga_2016,
    lga = region,
    year = census_year,
    value
  )

abs_employment <- abs_employment_raw %>%
  pivot_wider(
    names_from = sex,
    values_from = value
  ) %>%
  clean_names() %>%
  mutate(diff = persons - (males + females))

use_data(abs_employment)
