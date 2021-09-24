polymod_population <- get_polymod_population()

synthetic_settings_5y_polymod <- extrapolate_polymod(
  population = polymod_population
)

test_that("Matrix is named appropriately", {
  expect_snapshot(names(synthetic_settings_5y_polymod))
})

library(purrr)
test_that("Matrix dimensions are kept", {
  expect_snapshot(map(synthetic_settings_5y_polymod, dim))
})
