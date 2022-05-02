library(readxl)
library(dplyr)
library(tidyverse)
library(conmat)
library(janitor)


# Data : 15+ ages -> currently studying. Includes those who are studying for non school qualifications
abs_data <- list()
year_data <- tibble(code = 2:10, year = 2013:2021)
clean_data <- function(data) {
  clean_data <-  data %>%
    head(8) %>%
    rename(state = ...1) %>%
    select(1:10) %>%
    mutate(across(2:10,
                  ~ as.numeric(.x))) %>%
    pivot_longer(cols = 2:10,
                 names_to = "age_group",
                 values_to = "population_in_thousands") %>%
    mutate(age_group = str_remove_all(age_group, "[years]"),
           age_group = as.factor(age_group))
  return(clean_data)
}

for (i in 2:10)
{
  abs <-
    read_excel(
      "data-raw/ABS_Education_and _work_ 2021_Datacube2_Table11.xlsx",
      sheet = i,
      skip = 4
    ) %>% tail(-3) %>%
    mutate(...1 = toupper(...1),
           ...1 = str_remove(...1, "[.]"))
  
  abs_education_population <- clean_data(abs)
  abs_total_population <- abs %>%
    tail(-20)
  
  abs_total_population <- clean_data(abs_total_population)
  
  abs_data[[i - 1]] <- abs_education_population %>%
    inner_join(
      abs_total_population,
      by = c("state", "age_group"),
      suffix = c("", "_total")
    ) %>%
    mutate(proportion = population_in_thousands / population_in_thousands_total,
           year = i)
  
}

abs_education_2021 <- map_dfr(.x = abs_data, .f = bind_rows) %>%
  left_join(
    year_data,
    by = c("year" = "code"),
    keep = FALSE,
    suffix = c("", "")
  ) %>%
  mutate(across(
    population_in_thousands:population_in_thousands_total,
    ~ .x * 1000
  )) %>%
  rename(population_educated = population_in_thousands,
         estimated_population = population_in_thousands_total)

# For below 15 school goers

# Using under 15 full-time / part time school goers 

# Proportion calculated by retrieving age, state wise quarterly estimated population from year 2013-2021. 


raw_abs_school <- read_excel(
  here::here(
    "data-raw/Table 42b Number of Full-time and Part-time Students2006-2021.xlsx"
  ),
  sheet = "Table 2",
  skip = 4,
  n_max = 72862,
  .name_repair = janitor::make_clean_names
) %>%
  # mutate(year = parse_number(year)) %>%
  mutate(across(state_territory:age,
                ~ str_sub(.x, start = 3))) %>%
  mutate(
    age = parse_number(age),
    age = case_when(age == 4 ~ "4-",
                    age == 21 ~ "21+",
                    TRUE ~ as.character(age)),
    state_territory = str_remove(state_territory, "[.]")
  ) %>%
  rename(
    state = state_territory,
    anr_school_level = national_report_on_schooling_anr_school_level,
    grade = year_grade,
    n_full_time = full_time_student_count,
    n_part_time = part_time_student_count,
    n_full_and_part_time = all_full_time_and_part_time_student_count
  )

abs_below_15_education <- raw_abs_school %>%
  relocate(
    year,
    state,
    sex,
    grade,
    age,
    n_full_time,
    n_part_time,
    n_full_and_part_time,
    everything()
  ) %>%
  select(
    -anr_school_level,-starts_with("affiliation"),-n_full_time,-n_part_time,-grade,-school_level
  ) %>%
  group_by(year,
           state,
           aboriginal_and_torres_strait_islander_status,
           age) %>%
  summarise(n_full_and_part_time = sum(n_full_and_part_time)) %>%
  # NOTE
  # we are collapsing 4 and under into 4
  # and 21 and older into 21
  mutate(age = parse_number(age),
         state = toupper(state)) %>%
  arrange(age) %>%
  ungroup() %>%
  filter(age < 15,
         year >= 2013) %>%
  group_by(year, state, age) %>%
  summarise(population_educated = sum(n_full_and_part_time)) %>%
  ungroup() %>%
  complete(year,
           state,
           age = 0:14,
           fill = list(population_educated = 0))

# data downloaded from https://explore.data.abs.gov.au/vis?tm=quarterly%20population&pg=0&df[ds]=ABS_ABS_TOPICS&df[id]=ERP_Q&df[ag]=ABS&df[vs]=1.0.0&hc[Frequency]=Quarterly&pd=2019-Q2%2C&dq=1.3.TOT..Q&ly[cl]=TIME_PERIOD&ly[rw]=REGION


population_data <-
  read_csv("data-raw/population_data.csv",
           show_col_types = FALSE,
           trim_ws = TRUE) %>% select(4, 5, 7, 8) %>%
  rename(
    age_group = "AGE: Age",
    state = "REGION: Region",
    year = "TIME_PERIOD: Time Period",
    estimated_population = OBS_VALUE
  ) %>%
  mutate(
    across(age_group:estimated_population,
           ~ gsub(".*:", "", .x)),
    state = str_trim(state),
    age_group = str_trim(age_group)
  ) %>%
  filter(str_detect(year, "Q4") | str_detect(year, "2021-Q3")) %>%
  mutate(year = parse_number(year)) %>%
  dplyr::filter(state != "Australia") %>%
  mutate(
    state = abbreviate_states(state),
    age_group = as.factor(age_group),
    estimated_population = as.numeric(estimated_population)
  )

abs_education_u15 <- abs_below_15_education %>%
  left_join(age_group_lookup,
            by = c("age" = "lower")) %>%
  select(-upper) %>%
  fill(age_group)  %>%
  group_by(age_group, state, year) %>%
  summarise(population_educated = sum(population_educated, na.rm = TRUE))  %>%
  left_join(population_data, by = c("age_group", "state", "year")) %>%
  mutate(proportion = population_educated / estimated_population)


bind_rows(abs_education_u15, abs_education_2021) %>%
  droplevels() -> abs_state_year_education_data

ggplot(abs_state_year_education) +
  geom_col(aes(x = age_group, y = proportion))

# abs_state_year_education%>%
#   group_by(state)%>%
#   group_map(~.x,.keep=TRUE)%>%
#   setNames(unique(abs_state_year_education$state))->A
