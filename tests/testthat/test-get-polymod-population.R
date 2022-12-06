test_that("get_polymod_contact_data() works", {
  set.seed(2021-10-4)
  expect_snapshot(get_polymod_contact_data())
})

test_that("get_polymod_population() works", {
  set.seed(2021-10-4)
  expect_snapshot(get_polymod_population())
})

test_that("get_polymod_setting_data() works", {
  set.seed(2021-10-4)
  expect_snapshot(get_polymod_setting_data())
})
