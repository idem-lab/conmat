library(readxl)
library(janitor)
library(tidyverse)
abs_education_state_raw <- read_excel(
  here::here("data-raw/Table 42b Number of Full-time and Part-time Students, 2006-2020.xlsx"),
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
  mutate(age = parse_number(age),
         state = toupper(state)) %>%
  arrange(age) %>%
  ungroup()

use_data(abs_education_state, overwrite = TRUE)
