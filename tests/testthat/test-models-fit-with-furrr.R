library(future)
library(purrr)
plan(multisession, workers = 4)
polymod_setting_data <- get_polymod_setting_data()
polymod_population <- get_polymod_population()

contact_model <- fit_setting_contacts(
  contact_data_list = polymod_setting_data,
  survey_population = polymod_population
)

contact_model_pred <- predict_setting_contacts(
  population = polymod_population,
  contact_model = contact_model,
  age_breaks = c(seq(0, 75, by = 5), Inf)
)

test_that("list names are kept", {
  expect_snapshot(names(contact_model))
  expect_snapshot(names(contact_model_pred))
})

test_that("Model fits", {
  expect_s3_class(contact_model[[1]], "bam")
  expect_s3_class(contact_model[[2]], "bam")
  expect_s3_class(contact_model[[3]], "bam")
  expect_s3_class(contact_model[[4]], "bam")
})

test_that("Model coefficients are the same", {
  expect_snapshot(names(contact_model[[1]]$coefficients))
  expect_snapshot(names(contact_model[[2]]$coefficients))
  expect_snapshot(names(contact_model[[3]]$coefficients))
  expect_snapshot(names(contact_model[[4]]$coefficients))
})

test_that("Matrix dims are kept", {
  expect_snapshot(map(contact_model_pred, dim))
})