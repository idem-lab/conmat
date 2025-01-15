library(purrr)
library(conmat)

test_that("get_abs_per_capita_household_size errors for some lgas", {
  skip_on_ci()
  expect_snapshot_error(map(
    .x = unique(abs_household_lga$lga),
    .f = ~ get_abs_per_capita_household_size(lga = .x)
  ))
})

test_that("check_lga_name errors for some lgas", {
  skip_on_ci()
  expect_snapshot_error(map(
    .x = unique(abs_household_lga$lga),
    .f = ~ check_lga_name(lga = .x)
  ))
})

# safe_get_abs_per_capita_household_size <- safely(get_abs_per_capita_household_size)
#
# household_per_capita_runs <- map(
#   .x = unique(abs_household_lga$lga),
#   .f = ~ safe_get_abs_per_capita_household_size(lga = .x)
# )

# t_household_per_capita_runs <- transpose(household_per_capita_runs)
# compact(t_household_per_capita_runs$error)


# thinking about which ones error?
# safe_check_lga_name <- safely(check_lga_name)
#
# check_lga_name_runs <- map(
#   .x = unique(abs_household_lga$lga),
#   .f = ~ safe_check_lga_name(lga = .x)
# )
#
# transpose_errors <- transpose(check_lga_name_runs)
#
# which_errors <- which(map_lgl(
#   transpose_errors$error,
#   \(x) !is.null(x)
# )
# )
