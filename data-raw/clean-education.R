library(readxl)
library(janitor)
library(tidyverse)
abs_education_state_raw <- read_excel(
  here("data-raw/Table 42b Number of Full-time and Part-time Students, 2006-2020.xlsx"),
  sheet = "Table 2",
  skip = 4,
  n_max = 68559,
  .name_repair = make_clean_names
) %>%
  mutate(year = parse_number(year)) %>%
  mutate(
    across(
      state_territory:age,
      ~ str_sub(.x, start = 3)
    )
  ) %>%
  mutate(
    age = parse_number(age),
    age = case_when(
      age == 4 ~ "4-",
      age == 21 ~ "21+",
      TRUE ~ as.character(age)
    )
  ) %>%
  rename(
    state = state_territory,
    anr_school_level = national_report_on_schooling_anr_school_level,
    grade = year_grade,
    n_full_time = full_time_student_count,
    n_part_time = part_time_student_count,
    n_full_and_part_time = all_full_time_and_part_time_student_count
  )

abs_education_state_raw %>%
  pull(sex) %>%
  unique()
abs_education_state_raw %>%
  pull(affiliation_gov_non_gov) %>%
  unique()
abs_education_state_raw %>%
  pull(affiliation_gov_cath_ind) %>%
  unique()
abs_education_state_raw %>%
  filter(year == 2020)

abs_education_state <- abs_education_state_raw %>%
  relocate(
    year,
    state,
    sex,
    grade,
    age,
    n_full_time,
    n_part_time,
    n_full_and_part_time,
    everything()
  ) %>%
  select(
    -anr_school_level,
    -starts_with("affiliation"),
    -n_full_time,
    -n_part_time,
    -grade,
    -school_level
  ) %>%
  group_by(
    year,
    state,
    aboriginal_and_torres_strait_islander_status,
    age
  ) %>%
  summarise(n_full_and_part_time = sum(n_full_and_part_time)) %>%
  # NOTE
  # we are collapsing 4 and under into 4
  # and 21 and older into 21
  mutate(age = parse_number(age)) %>%
  arrange(age) %>%
  ungroup()

abs_education_state_2020 <- abs_education_state %>%
  filter(year == 2020) %>%
  mutate(state = toupper(state)) %>%
  group_by(year, state, age) %>%
  summarise(value = sum(n_full_and_part_time)) %>%
  ungroup() %>%
  complete(
    year,
    state,
    age = 0:100,
    fill = list(value = 0)
  )

abs_state_age %>%
  pull(age_group) %>%
  unique() %>%
  parse_number()

abs_state_age_lookup <- abs_state_age %>%
  mutate(
    lower.age.limit = parse_number(age_group),
    state = abbreviate_states(state)
  ) %>%
  select(
    state,
    lower.age.limit,
    population
  ) %>%
  group_by(state) %>%
  nest() %>%
  mutate(age_function = map(data, get_age_population_function)) %>%
  select(-data) %>%
  summarise(
    pop = map_dbl(0:100, age_function),
    age = 0:100
  )

abs_state_age_lookup

abs_education_state_2020_interp <- abs_education_state_2020 %>%
  left_join(abs_state_age_lookup,
    by = c(
      "state",
      "age"
    )
  ) %>%
  mutate(prop = value / pop)

abs_education_state_2020_interp

abs_education_state_2020_interp$population[[2]]

abs_education_state_2020_interp

use_data(abs_education_state_2020)

abs_education_state_raw_table_notes <- read_excel(
  here("data-raw/Table 42b Number of Full-time and Part-time Students, 2006-2020.xlsx"),
  sheet = "Table 2",
  skip = 68563
)
abs_education_state_raw_table_notes
