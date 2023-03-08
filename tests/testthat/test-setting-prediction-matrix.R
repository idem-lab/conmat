age_breaks_0_80_plus <- c(seq(0, 80, by = 10), Inf)
one_by_nine <- matrix(1, nrow = 9, ncol = 9)

test_that("setting_prediction_matrix works", {
  expect_snapshot(
    setting_prediction_matrix(
      home = one_by_nine,
      work = one_by_nine,
      age_breaks = age_breaks_0_80_plus
    )
  )
})

mat_list <- list(
  home = one_by_nine,
  work = one_by_nine
)

test_that("as_setting_prediction_matrix works", {
  expect_snapshot(
    as_setting_prediction_matrix(
      mat_list,
      age_breaks = age_breaks_0_80_plus
    )
  )
})

setting_mat <- setting_prediction_matrix(
  home = one_by_nine,
  work = one_by_nine,
  age_breaks = age_breaks_0_80_plus
)

test_that("as_setting_prediction_matrix warns when setting pred matrix given", {
  expect_snapshot(
    as_setting_prediction_matrix(
      setting_mat,
      age_breaks = age_breaks_0_80_plus
    )
  )
})

test_that("as_setting_prediction_matrix fails when wrong object given", {
  expect_snapshot(
    error = TRUE,
    as_setting_prediction_matrix(
      iris,
      age_breaks = age_breaks_0_80_plus
    )
  )
})
