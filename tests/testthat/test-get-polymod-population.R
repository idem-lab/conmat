test_that("get_polymod_contact_data() works", {
  skip_on_ci()
  set.seed(2021-10-4)
  expect_snapshot_output(get_polymod_contact_data())
})

test_that("get_polymod_population() works", {
  skip_on_ci()
  set.seed(2021-10-4)
  expect_snapshot_output(get_polymod_population())
})

test_that("get_polymod_setting_data() works", {
  skip_on_ci()
  set.seed(2021-10-4)
  expect_snapshot_output(get_polymod_setting_data())
})