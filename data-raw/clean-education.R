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
  filter(year == 2020)

abs_education_state_raw_table_notes <- read_excel(
  here("data-raw/Table 42b Number of Full-time and Part-time Students, 2006-2020.xlsx"),
  sheet = "Table 2",
  skip = 68563
)
abs_education_state_raw_table_notes
