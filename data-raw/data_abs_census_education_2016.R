

# Data Source: Census of Population and Housing, 2016, TableBuilder

library(readr)
library(conmat)
library(janitor)
library(tidyverse)



# TYPP included

data_abs_state_education <-
  read_csv("data-raw/2016_census_education.csv", skip = 8) %>%
  row_to_names(row_number = 1) %>%
  select(-1) %>%
  filter(
    !`STATE (UR)` %in% c(
      "Total",
      NA,
      "Cells in this table have been randomly adjusted to avoid the release of confidential data. No reliance should be placed on small cells."
    )
  ) %>%
  # Institution (TYPP) stated, full-time/part-time status (STUP) not stated -> considered
  mutate(
    state = abs_abbreviate_states(`STATE (UR)`),
    state = replace_na(state, "OT")
  ) %>%
  rename(
    age = "AGEP Age",
    student_type = "STUP Full-Time/Part-Time Student Status"
  ) %>%
  select(state, age, student_type, Count) %>%
  filter(
    student_type %in% c(
      "Full-time student",
      "Part-time student",
      "Total",
      "Institution (TYPP) stated, full-time/part-time status (STUP) not stated"
    )
  ) %>%
  mutate(student_type = case_when(
    str_detect(student_type, "TYPP") ~ "TYPP",
    TRUE ~ as.character(student_type)
  )) %>%
  pivot_wider(
    names_from = student_type,
    values_from = Count,
    values_fn = list
  ) %>%
  unnest(cols = everything()) %>%
  mutate(total_population = as.numeric(Total)) %>%
  mutate(
    age = as.numeric(age),
    year = 2016,
    population_educated = as.numeric(`Full-time student`) +
      as.numeric(`Part-time student`) + as.numeric(`TYPP`),
    proportion = population_educated / total_population
  ) %>%
  mutate(proportion = case_when(
    total_population == 0 & population_educated == 0 ~ 0,
    TRUE ~ as.numeric(proportion)
  )) %>%
  # filter(total_population != 0) %>%
  select(
    year,
    state,
    age,
    population_educated,
    total_population,
    proportion
  )
#
data_abs_state_education %>%
  ggplot(aes(x = age, y = proportion)) +
  geom_point() +
  facet_wrap(~state)

use_data(data_abs_state_education, compress = "xz", overwrite = TRUE)

#
# data_census_education %>%
#   filter(state == "VIC", age > 90) %>%
#   ggplot(aes(x = age, y = proportion)) +
#   geom_point()
#
# data_agg_data <- data_census_education %>%
#   mutate(
#     age_group = case_when(
#       # preschool
#       age %in% 2:4 ~ "2-4",
#       # compulsory education
#       age %in% 5:16 ~ "5-16",
#       # voluntary education
#       age %in% 17:18 ~ "17-18",
#       # university
#       age %in% 19:25 ~ "19-25",
#       # other
#       TRUE ~ "Other"
#     )
#   ) %>%
#   mutate(age_group = factor(age_group, levels = c("2-4", "5-16", "17-18", "19-25", "Other"))) %>%
#   group_by(age_group) %>%
#   summarise(prop = sum(population_educated) / sum(total_population))
#
# # TYPP not considered
#
# misc_census_education <-
#   read_csv("data-raw/2016_census_education.csv", skip = 8) %>%
#   row_to_names(row_number = 1) %>%
#   select(-1) %>%
#   filter(
#     !`STATE (UR)` %in% c(
#       "Other Territories" ,
#       "Total",
#       NA,
#       "Cells in this table have been randomly adjusted to avoid the release of confidential data. No reliance should be placed on small cells."
#     )
#   ) %>%
#   # Type of Educational Institution Attending (TYPP). Definition in below link
#   # https://www.abs.gov.au/ausstats/abs@.nsf/Lookup/by%20Subject/2900.0~2016~Main%20Features~TYPP%20Type%20of%20Educational%20Institution%20Attending~10086
#   # Institution (TYPP) stated, full-time/part-time status (STUP) not stated -> Not considered
#   mutate(state = abs_abbreviate_states(`STATE (UR)`)) %>%
#   rename(age = "AGEP Age",
#          student_type = "STUP Full-Time/Part-Time Student Status") %>%
#   select(state, age, student_type, Count) %>%
#   filter(student_type %in% c("Full-time student" , "Part-time student", "Total")) %>%
#   pivot_wider(names_from = student_type,
#               values_from = Count,
#               values_fn = list) %>%
#   unnest(cols = everything()) %>%
#   mutate(total_population = as.numeric(Total)) %>%
#   mutate(
#     age = as.numeric(age),
#     year = 2016,
#     population_educated = as.numeric(`Full-time student`) +
#       as.numeric(`Part-time student`),
#     proportion = population_educated / total_population
#   ) %>%
#   filter(total_population != 0) %>%
#   select(year,
#          state,
#          age,
#          population_educated,
#          total_population,
#          proportion)
#
# misc_census_education %>%
#   ggplot(aes(x = age, y = proportion)) +
#   geom_point() + facet_wrap( ~ state)
#
# misc_census_education %>%
#   filter(state == "VIC", age > 90) %>%
#   ggplot(aes(x = age, y = proportion)) +
#   geom_point()
#
# misc_census_education %>%
#   filter(state == "VIC", age > 90) %>%
#   arrange(-proportion)
#
# misc_agg_data <- misc_census_education %>%
#   mutate(
#     age_group = case_when(
#       # preschool
#       age %in% 2:4 ~ "2-4",
#       # compulsory education
#       age %in% 5:16 ~ "5-16",
#       # voluntary education
#       age %in% 17:18 ~ "17-18",
#       # university
#       age %in% 19:25 ~ "19-25",
#       # other
#       TRUE ~ "Other"
#     )
#   ) %>%
#   mutate(age_group = factor(age_group, levels = c("2-4", "5-16", "17-18", "19-25", "Other"))) %>%
#   group_by(age_group) %>%
#   summarise(prop_excluding_typp = sum(population_educated) / sum(total_population))
#
# misc_agg_data
#
# conmat_prop_data <-
#   tibble(
#     age_group = c("2-4", "5-16", "17-18", "19-25", "Other"),
#     conmat_prop = c(0.5, 1, 0.5, 0.1, 0.05)
#   )
#
# inner_join(conmat_prop_data,misc_agg_data) -> misc_comparison_table
#
# inner_join(conmat_prop_data,data_agg_data ) %>%
#   inner_join(misc_comparison_table) -> comparison_table
# comparison_table
