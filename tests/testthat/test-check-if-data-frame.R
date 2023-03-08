test_that("check_if_data_frame works", {
  expect_snapshot(
    check_if_data_frame(mtcars)
  )
  expect_snapshot(
    error = TRUE,
    check_if_data_frame(volcano)
  )
})
