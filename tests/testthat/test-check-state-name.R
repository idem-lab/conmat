test_that("abs_age_state() returns the right shape", {
  expect_snapshot(abs_age_state("NSW"))
})

test_that("abs_age_state() returns an error", {
  expect_snapshot(
    error = TRUE,
    abs_age_state("Imaginary World")
  )
})