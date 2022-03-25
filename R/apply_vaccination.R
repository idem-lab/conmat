ngm_NSW <- generate_ngm(
  state_name = "NSW", 
  age_breaks = c(seq(0, 80, by = 5), Inf),
  R_target = 1.5
) 

# ideal function 
# - takes in matrix ngm, with ordered vectors of coverage, acquisition and transmission efficacies
ngm_5y_fairfield_vacc_0.5 <- apply_vaccination(
  ngm = ngm_5y_fairfield,
  coverage_by_age = age_coverage,
  efficacy_acquistion = efficacy_acquisition,
  efficacy_transmission = efficacy_transmission
)

library(tidyverse)

ves <- read_csv("data/example_ves.csv", col_types = list(col_factor(), col_double(), col_double()))
coverage <- read_csv("data/example_coverage.csv", col_types = list(col_factor(), col_double()))

coverage
ves

ngm_NSW$all


ves %>%
  # join on coverages
  left_join(
    coverage,
    by = c("age_band")
  ) %>%
  # compute percentage reduction in acquisition and transmission in each age group
  mutate(
    acquisition_multiplier = 1 - acquisition * coverage,
    transmission_multiplier = 1 - transmission * coverage,
  ) %>%
  select(
    -acquisition,
    -transmission,
    -coverage
  ) %>%
  # transform these into matrices of reduction in transmission, matching the NGM
  summarise(
    transmission_reduction_matrix =
      list(
        outer(
          # 'to' groups are on the rows in conmat, and first element in outer is rows,
          # so acquisition first
          acquisition_multiplier,
          transmission_multiplier,
          FUN = "*"
        )
      ),
    .groups = "drop"
  ) %>%
  mutate(
    ngm_unvaccinated = list(ngm_NSW$all),
    ngm_vaccinated = list(ngm_unvaccinated[[1]] * transmission_reduction_matrix[[1]])
  ) %>%
  pull(ngm_vaccinated) %>%
  `[[`(1)

# Aarathy to tidy this as she sees fit.