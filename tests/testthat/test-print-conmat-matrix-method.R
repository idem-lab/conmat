perth_city <- abs_age_lga("Perth (C)")
set.seed(2022 - 12 - 14)
synthetic_settings_5y_perth <- extrapolate_polymod(
  population = perth_city
)

test_that("Print method for setting prediction matrices works", {
  expect_snapshot_output(synthetic_settings_5y_perth)
  expect_snapshot_output(synthetic_settings_5y_perth$home)
})
