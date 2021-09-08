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
      age == "85 and over" ~ "85+",
      age == "Total" ~ "total"
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
        "85+",
        "total"
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
  rename(age_group = age)

use_data(abs_employ_age_lga, overwrite = TRUE)
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


