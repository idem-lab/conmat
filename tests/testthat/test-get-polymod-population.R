test_that("get_polymod_contact_data() works", {
  options(pillar.print_max = 15)
  set.seed(2021-10-4)
  expect_snapshot_output(get_polymod_contact_data())
})

test_that("get_polymod_population() works", {
  options(pillar.print_max = 15)
  set.seed(2021-10-4)
  expect_snapshot_output(get_polymod_population())
})

test_that("get_polymod_setting_data() works", {
  options(pillar.print_max = 15)
  set.seed(2021-10-4)
  expect_snapshot_output(get_polymod_setting_data())
})