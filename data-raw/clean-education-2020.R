library(tidyverse)
library(conmat)
abs_state_age_lookup

agebreaks <- seq(5, 95, by = 5)

lookup <- tibble(
  lower = c(0, agebreaks, 100),
  upper = c(agebreaks-1, 99, Inf),
  age_group = as.character(glue::glue("{lower}-{upper}"))
) %>% 
  mutate(
    age_group = case_when(
      age_group == "100-Inf" ~ "100+",
      TRUE ~ age_group
    ),
    age_group = factor(age_group,
                       levels = str_sort(age_group, numeric = TRUE))
  ) %>% 
  arrange(age_group)



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

abs_education_state_2020_raw %>%
  left_join(abs_state_age_lookup,
            by = c(
              "state",
              "age"
            )
  ) %>% 
  left_join(
    lookup,
    by = c("age" = "lower")
  ) %>% 
  select(-upper) %>% 
  fill(age_group) %>% 
  group_by(year, state, age_group) %>% 
  summarise(population = sum(population),
            population_interpolated = sum(population_interpolated)) %>% 
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
