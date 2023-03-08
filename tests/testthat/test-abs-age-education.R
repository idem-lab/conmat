test_that("abs_age_education_state works", {
  expect_snapshot(
    abs_age_education_state(state = "VIC")
  )
  expect_snapshot(
    abs_age_education_state(state = "WA", age = 1:5)
  )
  expect_snapshot(
    abs_age_education_state(state = c("QLD", "TAS"), age = 5)
  )
})

test_that("abs_age_education_state works", {
  expect_snapshot(
    abs_age_education_lga(lga = "Albury (C)")
  )
  expect_snapshot(
    abs_age_education_lga(lga = "Albury (C)", age = 1:5)
  )
  expect_snapshot(
    abs_age_education_lga(lga = c("Albury (C)", "Barcoo (S)"), age = 10)
  )
})
