library(dplyr)
library(stringr)

agebreaks <- seq(5, 95, by = 5)

age_group_lookup <- tibble(
  lower = c(0, agebreaks, 100),
  upper = c(agebreaks-1, 99, Inf),
  age_group = as.character(glue::glue("{lower}-{upper}"))
) %>% 
  mutate(
    age_group = case_when(
      age_group == "100-Inf" ~ "100+",
      TRUE ~ age_group
    ),
    age_group = factor(age_group,
                       levels = str_sort(age_group, numeric = TRUE))
  ) %>% 
  arrange(age_group)

use_data(age_group_lookup, compress = "xz", overwrite = TRUE)
