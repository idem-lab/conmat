library(readxl)
library(janitor)
library(tidyverse)
library(conmat)
abs_education_state_pre <- read_excel(
  here::here("data-raw/Table 42b Number of Full-time and Part-time Students, 2006-2020.xlsx"),
  sheet = "Table 2",
  skip = 4,
   n_max = 68559,
 .name_repair = make_clean_names
# 
) %>%
  mutate(year = parse_number(year)) %>%
  mutate(
    across(
      state_territory:age,
      ~ str_sub(.x, start = 3)
    )
  )%>%
  rename(
    state = state_territory,
    anr_school_level = national_report_on_schooling_anr_school_level,
    grade = year_grade,
    n_full_time = full_time_student_count,
    n_part_time = part_time_student_count,
    n_full_and_part_time = all_full_time_and_part_time_student_count
  )%>%
  mutate(
    age = parse_number(age),
    state = toupper(state)
  )
# NOTE
# we are collapsing 4 and under into 4
# and 21 and older into 21

abs_education_state <- abs_education_state_pre %>%
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
    -anr_school_level,
    -starts_with("affiliation"),
    -n_full_time,
    -n_part_time,
    -grade,
    -school_level
  ) %>%
  group_by(
    year,
    state,
   aboriginal_and_torres_strait_islander_status,
    age
  ) %>%
  summarise(n_full_and_part_time = sum(n_full_and_part_time)) %>%
  arrange(age) %>%
  ungroup()

# Complete ages. Note that 21 holds the data for 21 and above ages. Same goes with 4 and younger. 
abs_education_state_2020_raw <- abs_education_state %>%
  filter(year == 2020) %>%
  group_by(year, state, age) %>%
  summarise(population_educated = sum(n_full_and_part_time)) %>%
  ungroup() %>%
  complete(
    year,
    state,
    age = 0:100,
    fill = list(population_educated = 0)
  )
  
# Get interpolation population for ages 0:100

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

 

#possible reasons for the issues in abs_education_state_2020 
# the population_educated for ages above 21 is shown as 0
 # when that data was already given in ages 21 and over. The same applies for 4 years and younger

# School going population grouped as 2-4,5-16,17-18,19-20 and 21+. 
# Same results shown when 0-4 and 21+ is shown as Other
school_prop <-  abs_education_state_2020_raw%>%
  mutate(school_age_group=case_when(
    between(age,0,1)~"0-1",
    between(age,2,4)~"2-4",
    between(age,5,16)~"5-16",
    between(age,17,18)~"17-18",
    between(age,19,20)~"19-20",
    TRUE ~ "21+"
  )) %>%
  mutate(school_age_group = factor(school_age_group, levels = c(
    "0-1", "2-4", "5-16", "17-18",
    "19-20", "21+"
  )))%>%
  left_join(abs_state_age_lookup,
            by = c(
              "state",
              "age"
            )
  ) %>%
  group_by(school_age_group) %>% 
  summarise(population_educated = sum(population_educated, na.rm = TRUE),
            population_interpolated = sum(population_interpolated, na.rm = TRUE)) %>% 
  mutate(prop = population_educated / population_interpolated)
school_prop
 

 
library(ggplot2)
options(scipen = 999)
ggplot(
  school_prop,
  aes(
    x = population_educated,
    y = population_interpolated,
    color=school_age_group
  )
) +
  geom_point() +
  geom_abline()+
  theme(aspect.ratio = 1) + 
  facet_wrap(~state,
             ncol = 4,
             scales = "free_x")

## Misc Code
abs_education_state_2020_aggregated <- abs_education_state_2020_raw %>% 
  left_join(
    age_group_lookup,
    by = c("age" = "lower")
  ) %>% 
  select(-upper) %>% 
  fill(age_group) %>% 
  group_by(year, state, age_group) %>% 
  summarise(population_educated = sum(population_educated, na.rm = TRUE))

abs_ed_state_2020_age_group <- abs_education_state_2020_raw %>%
  left_join(abs_state_age_lookup,
            by = c(
              "state",
              "age"
            )
  ) %>% 
  left_join(
    age_group_lookup,
    by = c("age" = "lower")
  ) %>% 
  select(-upper) %>% 
  fill(age_group) %>% 
  mutate(age_group=case_when(
    !(age %in% c(0:20)) ~"21+",
    TRUE ~ as.character(age_group)
  ))  %>%
  group_by(age_group) %>% 
  summarise(population_educated = sum(population_educated, na.rm = TRUE),
            population_interpolated = sum(population_interpolated, na.rm = TRUE)) %>% 
  mutate(prop = population_educated / population_interpolated)