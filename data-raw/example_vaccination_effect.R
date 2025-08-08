vaccination_effect_example_data <- minty::read_csv(
  "data-raw/example_vaccine_coverage_effects.csv"
) %>%
  select(age_band, coverage, acquisition, transmission) %>%
  tibble::as_tibble()

use_data(vaccination_effect_example_data, overwrite = TRUE, compress = "xz")
