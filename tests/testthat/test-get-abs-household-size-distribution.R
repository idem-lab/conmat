test_that("get_abs_household_size_distribution works", {
  expect_snapshot(
    get_abs_household_size_distribution(lga = "Fairfield (C)")
  )
  expect_snapshot(
    get_abs_household_size_distribution(state = "NSW")
  )
})
