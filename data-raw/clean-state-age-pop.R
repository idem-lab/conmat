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
  stats::setNames(abs_state_age_names) %>%
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
  ) %>%
  mutate(state = abs_abbreviate_states(state)) %>%
  relocate(
    state,
    age_group,
    population
  ) %>%
  mutate(
    # replace emdash.
    age_group = str_replace_all(
      age_group,
      "–",
      "-"
    ),
    age_group = case_when(
      age_group == "100 and over" ~ "100+",
      TRUE ~ age_group
    ),
    age_group = factor(
      age_group,
      levels = str_sort(unique(age_group), numeric = TRUE)
    )
  )

abs_state_age

use_data(abs_state_age, overwrite = TRUE)

abs_state_age %>%
  pull(state) %>%
  unique()

abs_state_age %>%
  group_by(state) %>%
  summarise(pop = sum(population))
