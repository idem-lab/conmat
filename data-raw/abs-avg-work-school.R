## code to prepare `abs-avg-work-school` dataset goes here
library(tidyverse)
abs_avg_work <- data_abs_state_work %>%
  group_by(
    age
  ) %>%
  summarise(
    work_fraction = mean(proportion)
  )

usethis::use_data(abs_avg_work, overwrite = TRUE)

abs_avg_school <- data_abs_state_education %>%
  group_by(
    age
  ) %>%
  summarise(
    school_fraction = mean(proportion)
  )

usethis::use_data(abs_avg_school, overwrite = TRUE)
