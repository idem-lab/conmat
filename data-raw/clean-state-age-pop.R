library(readxl)
library(here)
abs_state_age_names <- read_excel(
  here("data-raw/31010do001_202012.xls"),
  sheet = "Table_6",
  skip = 4,
  n_max = 1,
  # .name_repair = janitor::make_clean_names
) %>%
  names()

abs_state_age <- read_excel(
  here("data-raw/31010do001_202012.xls"),
  sheet = "Table_6",
  skip = 51,
  n_max = 22
) %>%
  setNames(abs_state_age_names) %>%
  pivot_longer(
    cols = -`Age group (years)`,
    names_to = "state",
    values_to = "population"
  ) %>%
  rename(
    age_group = `Age group (years)`
  ) %>%
  filter(
    age_group != "All ages",
    state != "Australia"
  )

use_data(abs_state_age)

abs_state_age %>%
  pull(age_group) %>%
  unique()

abs_state_age %>%
  group_by(state) %>%
  summarise(pop = sum(population))
