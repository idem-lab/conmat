library(dplyr)
set.seed(2022)

ngm_VIC <- generate_ngm_oz(
  state_name = "VIC",
  age_breaks = c(seq(0, 80, by = 5), Inf),
  R_target = 1.5
)

ngm_VIC_vacc <- apply_vaccination(
  ngm = ngm_VIC,
  data = vaccination_effect_example_data,
  coverage_col = coverage,
  acquisition_col = acquisition,
  transmission_col = transmission
)


test_that("apply_vaccination() returns expected matrices", {
  expect_true(purrr::map2_lgl(
    .x = ngm_VIC_vacc,
    .y = ngm_VIC,
    .f = function(.x, .y) {
      all(.x <= .y)
    }
  ) %>%
    all())
})

test_that("apply_vaccination() errors when there's an incorrect variable name", {
  expect_snapshot_error(
    apply_vaccination(
      ngm = ngm_VIC,
      data = vaccination_effect_example_data,
      coverage_col = coverage,
      acquisition_col = acquisition_column,
      transmission_col = transmission
    )
  )
})

test_that("apply_vaccination() produces expected output", {
  expect_snapshot(
    ngm_VIC_vacc
  )
})