library(tidyverse)
library(conmat)
abs_state_age_lookup
age_group_lookup

abs_education_state_2020_raw <- abs_education_state %>%
  filter(year == 2020) %>%
  group_by(year, state, age) %>%
  summarise(population_educated = sum(n_full_and_part_time)) %>%
  ungroup() %>%
  complete(
    year,
    state,
    age = 0:100,
    fill = list(population = 0)
  ) 

abs_education_state_2020_aggregated <- abs_education_state_2020_raw %>% 
  left_join(
    age_group_lookup,
    by = c("age" = "lower")
  ) %>% 
    select(-upper) %>% 
    fill(age_group) %>% 
  group_by(year, state, age_group) %>% 
  summarise(population_educated = sum(population_educated, na.rm = TRUE))

abs_education_state_2020_aggregated %>% 
  left_join(
    abs_state_age,
    by = c("state",
           "age_group")) %>% 
  mutate(prop = population_educated / population)

abs_state_age_lookup <- abs_state_age %>%
  mutate(
    lower.age.limit = parse_number(as.character(age_group)),
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
  summarise(population_educated = sum(population_educated, na.rm = TRUE),
            population_interpolated = sum(population_interpolated, na.rm = TRUE)) %>% 
  mutate(prop = population_educated / population_interpolated) 

abs_education_state_2020

use_data(abs_education_state_2020, compress = "xz", overwrite = TRUE)

abs_education_state_2020$population[[2]]

abs_education_state_2020

abs_education_state_raw_table_notes <- read_excel(
  here("data-raw/Table 42b Number of Full-time and Part-time Students, 2006-2020.xlsx"),
  sheet = "Table 2",
  skip = 68563
)
abs_education_state_raw_table_notes
