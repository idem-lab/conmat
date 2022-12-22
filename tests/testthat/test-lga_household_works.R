library(purrr)
library(conmat)

test_that("get_per_capita_household_size errors for some lgas", {
  skip_on_ci()
  expect_snapshot_error(map(
    .x = unique(abs_household_lga$lga),
    .f = ~ get_per_capita_household_size(lga = .x)
  ))
})
safe_get_per_capita_household_size <- safely(get_per_capita_household_size)

household_per_capita_runs <- map(
  .x = unique(abs_household_lga$lga),
  .f = ~ safe_get_per_capita_household_size(lga = .x)
)

# t_household_per_capita_runs <- transpose(household_per_capita_runs)
# compact(t_household_per_capita_runs$error)

test_that("check_lga_name errors for some lgas", {
  skip_on_ci()
  expect_snapshot_error(map(
    .x = unique(abs_household_lga$lga),
    .f = ~ check_lga_name(lga = .x)
  ))
})

safe_check_lga_name <- safely(check_lga_name)

check_lga_name_runs <- map(
  .x = unique(abs_household_lga$lga),
  .f = ~ safe_check_lga_name(lga = .x)
)

# t_check_lga_name_runs <- transpose(check_lga_name_runs)
# compact(t_check_lga_name_runs$error)
