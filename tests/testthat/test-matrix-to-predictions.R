fairfield <- abs_age_lga("Fairfield (C)")

fairfield_school_contacts <- predict_contacts(
  model = polymod_setting_models$school,
  population = fairfield,
  age_breaks = c(0, 5, 10, 15, Inf)
)

fairfield_school_mat <- predictions_to_matrix(fairfield_school_contacts)

test_that("matrix_to_predictions works", {
  expect_snapshot(
    matrix_to_predictions(fairfield_school_mat)
  )
})

test_that("predictions_to_matrix works", {
  expect_snapshot(
    predictions_to_matrix(fairfield_school_contacts)
  )
})
