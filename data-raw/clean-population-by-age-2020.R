library(readxl)
library(tidyverse)
library(here)
library(janitor)
# data downloaded from https://www.abs.gov.au/statistics/people/population/regional-population-age-and-sex/2020/32350DS0003_2020.xls
file_path <- here("data-raw/32350DS0003_2020.xls")
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

abs_pop_age_lga_2020 <- file_path %>%
  read_excel(
    sheet = "Table 3",
    skip = 10,
    col_names = names
  ) %>%
  select(
    -`S/T code`,
    -`Total persons`
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
  mutate(year = 2020, .before = state) %>%
  rename(
    lga_code = lga_code19,
    lga_name = lga_name19
  )

use_data(abs_pop_age_lga_2020, overwrite = TRUE)
