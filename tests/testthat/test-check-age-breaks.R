age_one <- c(1, 2, 3, Inf)
age_two <- c(1, 2, 3)

test_that("check_age_breaks works", {
  expect_snapshot(
    check_age_breaks(age_one, age_one)
  )

  expect_snapshot(
    error = TRUE,
    check_age_breaks(age_one, age_two)
  )
})
