test_that("abs_age_lga() returns the right shape works", {
  expect_snapshot(abs_age_lga("Albury (C)"))
})

test_that("abs_age_lga() returns the right shape errors", {
  expect_snapshot_error(
    abs_age_lga("Imaginary World")
    )
})
