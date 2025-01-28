library(tidyverse)
library(janitor)


aus_states <- c(
  "New South Wales", "Victoria", "Queensland",
  "South Australia",
  "Western Australia",
  "Tasmania",
  "Northern Territory",
  "Australian Capital Territory"
)

abs_census_labour_status <- read_csv("data-raw/2016_abs_census_labour_status.csv",
  skip = 8, n_max = 138
)

get_data <- function(i) {
  abs_census_labour_status %>%
    slice(i:c(i + 11)) %>%
    slice(-1) %>%
    row_to_names(1) %>%
    rename(Status = `AGEP Age`) %>%
    select(-`Total`) %>%
    pivot_longer(-Status, names_to = "Age", values_to = "population") %>%
    filter(grepl("Employed|Total", Status)) %>%
    pivot_wider(names_from = Status, values_from = population) %>%
    clean_names() %>%
    # filter(total!= 0)%>%
    mutate(
      year = 2016,
      age = as.numeric(age),
      employed_population = as.numeric(employed_worked_full_time +
        employed_worked_part_time +
        employed_away_from_work),
      proportion = employed_population / total,
      state = abs_census_labour_status$...1[[i]]
    ) %>%
    mutate(
      state = conmat::abs_abbreviate_states(state),
      state = replace_na(state, "OT")
    ) %>%
    select(year, state, age, employed_population, total_population = total, proportion) %>%
    mutate(proportion = case_when(
      total_population == 0 & employed_population == 0 ~ 0,
      TRUE ~ as.numeric(proportion)
    ))
}


data_abs_state_work <- map_dfr(seq(1, 113, 14), get_data)

use_data(data_abs_state_work, compress = "xz", overwrite = TRUE)

data_abs_state_work_2016 %>%
  ggplot(aes(x = age, y = proportion)) +
  geom_point() +
  facet_wrap(~state)

# maybe mention in the documentation that data from abs have been randomly adjusted
# to avoid the release of confidential data.
# No reliance should be placed on small cells.

data_abs_state_work_2016 %>%
  filter(state == "VIC") %>%
  arrange(-proportion)


work_fraction <- ~ dplyr::case_when(
  # child labour
  .x %in% 12:19 ~ 0.2,
  # young adults (not at school)
  .x %in% 20:24 ~ 0.7,
  # main workforce
  .x %in% 25:60 ~ 1,
  # possibly retired
  .x %in% 61:65 ~ 0.7,
  # other
  TRUE ~ 0.05
)

work_fraction <- data_abs_state_work_2016 %>%
  mutate(age_group = case_when(
    # child labour
    age %in% 12:19 ~ "12-19",
    # young adults (not at school)
    age %in% 20:24 ~ "20-24",
    # main workforce
    age %in% 25:60 ~ "25-60",
    # possibly retired
    age %in% 61:65 ~ "61-64",
    # other
    TRUE ~ "Other"
  )) %>%
  group_by(age_group) %>%
  summarise(work_fraction = sum(employed_population) / sum(total_population))


conmat_work_prop_data <-
  tibble(
    age_group = c("12-19", "20-24", "25-60", "61-64", "Other"),
    conmat_work_prop = c(0.2, 0.7, 1, 0.7, 0.05)
  )

work_fraction_comparison_table <- inner_join(
  conmat_work_prop_data, 
  work_fraction, 
  by = "age_group"
  )

work_fraction_comparison_table
