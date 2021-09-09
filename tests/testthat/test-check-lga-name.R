test_that("check_lga_name() returns the right shape", {
  expect_silent(check_lga_name("Albury (C)"))
})

test_that("check_lga_name() errors", {
  expect_snapshot(
    error = TRUE,
    check_lga_name("Imaginary World")
  )
})