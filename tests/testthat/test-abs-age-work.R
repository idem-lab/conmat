test_that("abs_age_work_state works", {
  expect_snapshot(
    abs_age_work_state(state = "NSW")
  )
  expect_snapshot(
    abs_age_work_state(state = c("QLD", "TAS"), age = 5)
  )
})

test_that("abs_age_work_lga works", {
  expect_snapshot(
    abs_age_work_lga(lga = "Albany (C)", age = 1:5)
  )
  expect_snapshot(
    abs_age_work_lga(lga = c("Albury (C)", "Barcoo (S)"), age = 39)
  )
})
