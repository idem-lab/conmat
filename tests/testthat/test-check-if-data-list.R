test_that("check_if_list() returns error when argument class is not a list", {
  set.seed(2021 - 10 - 4)
  polymod_setting_data <- get_polymod_setting_data()
  expect_snapshot_error(check_if_list(polymod_setting_data$home))
})

test_that("check_if_list() returns nothing when argument class is a list", {
  set.seed(2021 - 10 - 4)
  polymod_setting_data <- get_polymod_setting_data()
  expect_silent((check_if_list(polymod_setting_data)))
})
