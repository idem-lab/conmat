library(readr)
library(tidyverse)
library(here)
library(janitor)
employment_path <- here("data-raw/ABS_C16_G43_LGA_06092021163109650.csv.zip")
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

abs_employ_age_lga <- abs_employment_raw %>%
  pivot_wider(
    names_from = sex,
    values_from = value
  ) %>%
  clean_names() %>%
  # remove "total"
  filter(age != "Total") %>% 
  mutate(
    diff = persons - (males + females),
    age = case_when(
      age == "15 - 19" ~ str_remove_all(age, " "),
      age == "20 - 24" ~ str_remove_all(age, " "),
      age == "25 - 34" ~ str_remove_all(age, " "),
      age == "35 - 44" ~ str_remove_all(age, " "),
      age == "45 - 54" ~ str_remove_all(age, " "),
      age == "55 - 64" ~ str_remove_all(age, " "),
      age == "65 - 74" ~ str_remove_all(age, " "),
      age == "75 - 84" ~ str_remove_all(age, " "),
      age == "85 and over" ~ "85+"
      # age == "Total" ~ "total"
    ),
    age = factor(
      age,
      levels = c(
        "15-19",
        "20-24",
        "25-34",
        "35-44",
        "45-54",
        "55-64",
        "65-74",
        "75-84",
        "85+"
        # "total"
      )
    )
  ) %>%
  relocate(
    year,
    state,
    lga,
    lga_code,
    labour_force_status,
    age,
    everything()
  ) %>% 
  filter(str_detect(labour_force_status, "Total")) %>% 
  select(-males,
         -females,
         -diff) %>% 
  pivot_wider(
    names_from = labour_force_status,
    values_from = persons
  ) %>% 
  clean_names() %>% 
  mutate(state = abbreviate_states(state)) %>%
  # drop "other territories"
  drop_na() %>% 
  select(-lga_code) %>% 
  rename(age_group = age) %>% 
  select(year,
         state,
         lga,
         age_group,
         total_employed)

abs_employ_age_lga %>% pull(age_group)

abs_employ_age_lga


use_data(abs_employ_age_lga, overwrite = TRUE)

# interpolation stuff
abs_employ_age_lga %>% 
  ungroup() %>%
  # take the lower? age group?
  mutate(age = parse_number(as.character(age_group))) %>% 
  complete(
    year,
    state,
    lga,
    age = 0:100,
    fill = list(total_employed = 0)
  ) %>% 
  select(-age_group) %>% 
  left_join(
    age_group_lookup,
    by = c("age" = "lower")
  ) %>% 
  select(-upper) %>% 
  fill(age_group) %>% 
  mutate(
    lower.age.limit = parse_number(as.character(age_group)),
  ) %>% 
  select(
    state,
    lga,
    lower.age.limit,
    total_employed
  )  %>% 
  group_by(state) %>%
  nest() %>% 
  mutate(age_function = map(data, get_age_population_function))
  select(-data) %>%
  summarise(
    population_interpolated = map_dbl(0:100, age_function),
    age = 0:100
  )

abs_employ_age_lga

hist(abs_employ_age_lga$diff)

unique(abs_employ_age_lga$age)
unique(abs_employ_age_lga$labour_force_status)



abs_employ_age_lga %>%
  arrange(lga, age, labour_force_status)

abs_employ_age_lga %>%
  mutate(abs_pct = (abs(diff) / persons) * 100) %>%
  pull(abs_pct) %>%
  hist()


