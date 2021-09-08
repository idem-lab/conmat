library(conmat)
abs_education_state_2020_raw <- abs_education_state %>%
  filter(year == 2020) %>%
  group_by(year, state, age) %>%
  summarise(population = sum(n_full_and_part_time)) %>%
  ungroup() %>%
  complete(
    year,
    state,
    age = 0:100,
    fill = list(population = 0)
  )

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
    population_interpolated = map_dbl(0:100, age_function),
    age = 0:100
  )

abs_state_age_lookup

abs_education_state_2020 <- abs_education_state_2020_raw %>%
  left_join(abs_state_age_lookup,
            by = c(
              "state",
              "age"
            )
  ) %>%
  mutate(prop = population / population_interpolated)

abs_education_state_2020

use_data(abs_education_state_2020, overwrite = TRUE)

abs_education_state_2020$population[[2]]

abs_education_state_2020

abs_education_state_raw_table_notes <- read_excel(
  here("data-raw/Table 42b Number of Full-time and Part-time Students, 2006-2020.xlsx"),
  sheet = "Table 2",
  skip = 68563
)
abs_education_state_raw_table_notes
