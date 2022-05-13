library(readr)
library(tidyverse)
library(janitor)

abs_census_lga_work <-
  read_csv(
    "data-raw/2016_abs_census_lga_work.csv",
    col_types = cols(...1 = col_character()),
    skip = 8,
    n_max = 65873
  ) %>% row_to_names(1) %>% clean_names() %>%
  rename(age = na,
         lga = lfsp_labour_force_status) %>%
  slice(-1) %>%
  mutate(
    year = 2016,
    employed_worked_full_time = as.numeric(employed_worked_full_time),
    employed_worked_part_time = as.numeric(employed_worked_part_time),
    employed_away_from_work = as.numeric(employed_away_from_work),
    total = as.numeric(total)
  )

for (i in 1:nrow(abs_census_lga_work))
{
  if (is.na(abs_census_lga_work$age[i]) == TRUE) {
    abs_census_lga_work$age[i] <- abs_census_lga_work$age[i - 1]
  } else {
    abs_census_lga_work$age[i] <- abs_census_lga_work$age[i]
  }
}

# new total calculated as total in the data is giving weird values such as < employed people in the given lga. Check
# Etheridge (S)for age 46


data_abs_census_lga_work <- abs_census_lga_work %>%
  filter(age != "Total") %>%
  mutate(across(.cols = -lga, .fn = as.numeric)) %>%
  mutate(
    cal_total = c(
      employed_worked_full_time +
        employed_worked_part_time +
        employed_away_from_work +
        unemployed_looking_for_full_time_work +
        unemployed_looking_for_part_time_work +
        not_in_the_labour_force +
        not_stated +
        not_applicable
    )
  ) %>%
  arrange(lga) %>%
  filter(total != 0) %>%
  mutate(
    employed_population = as.numeric(
      employed_worked_full_time +
        employed_worked_part_time +
        employed_away_from_work
    ),
    proportion = employed_population / total,
    cal_prop = employed_population / cal_total
  ) %>%
  select(
    year,
    lga,
    age,
    employed_population,
    total_population = total,
    cal_total,
    proportion,
    cal_prop
  )
