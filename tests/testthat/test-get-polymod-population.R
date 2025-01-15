test_that("get_polymod_contact_data() works", {
  skip_on_ci()
  set.seed(2021 - 10 - 4)
  expect_snapshot(get_polymod_contact_data())
})

test_that("get_polymod_population() works", {
  skip_on_ci()
  set.seed(2021 - 10 - 4)
  expect_snapshot(get_polymod_population())
})

test_that("get_polymod_setting_data() and derivatives work", {
  skip_on_ci()
  set.seed(2021 - 10 - 4)
  polymod_setting_data <- get_polymod_setting_data()
  expect_snapshot(polymod_setting_data)
  expect_snapshot(polymod_setting_data$home)
  expect_snapshot(polymod_setting_data$work)
  expect_snapshot(polymod_setting_data$school)
  expect_snapshot(polymod_setting_data$other)
})
