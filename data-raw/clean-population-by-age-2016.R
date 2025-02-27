library(readxl)
library(tidyverse)
library(here)
library(janitor)
# data from https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/3235.02016?OpenDocument
# Population Estimates by Age and Sex, Local Government Areas (ASGS 2016), 2016 - Final
file_path <- here("data-raw/32350ds0015_lga_2016.xls")
names_1 <- file_path %>%
  read_excel(
    sheet = "Table 3",
    skip = 8,
    n_max = 1
  ) %>%
  names()
names_2 <- file_path %>%
  read_excel(
    sheet = "Table 3",
    skip = 7,
    n_max = 1
  ) %>%
  names()

names <- c(names_1[1:4], names_2[-(1:4)])
abs_pop_age_lga_2016_raw <- file_path %>%
  read_excel(
    sheet = "Table 3",
    skip = 10,
    col_names = names
  ) %>%
  select(
    -`S/T code`,
    -`Total Persons`
  ) %>%
  rename(
    `85+` = `85 and over`,
    state = `S/T name`,
    LGA_NAME19 = `LGA name`,
    LGA_CODE19 = `LGA code`
  ) %>%
  pivot_longer(
    cols = -c(state, LGA_NAME19, LGA_CODE19),
    names_to = "age",
    values_to = "population"
  ) %>%
  # death to em-dashes
  mutate(age = str_replace(age, "–", "-")) %>%
  clean_names() %>%
  mutate(
    year = 2016,
    .before = state
  ) %>%
  rename(
    lga_code = lga_code19,
    lga = lga_name19
  ) %>%
  mutate(state = abs_abbreviate_states(state)) %>%
  select(-lga_code) %>%
  rename(age_group = age) %>%
  # replace emdash
  mutate(
    age_group = str_replace_all(
      age_group,
      "–",
      "-"
    ),
    age_group = factor(
      age_group,
      levels = str_sort(unique(age_group), numeric = TRUE)
    )
  ) %>%
  arrange(
    state,
    age_group
  )

# there's about 1% missing...
abs_pop_age_lga_2016_raw %>%
  naniar::miss_var_summary()

abs_pop_age_lga_2016 <- abs_pop_age_lga_2016_raw %>%
  drop_na()

use_data(abs_pop_age_lga_2016, overwrite = TRUE)
