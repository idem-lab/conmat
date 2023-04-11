library(future)
library(purrr)
library(dplyr)
plan(multisession, workers = 4)
polymod_setting_data <- get_polymod_setting_data()
polymod_population <- get_polymod_population()

polymod_setting_short <- map(
  .x = polymod_setting_data,
  .f = function(x) {
    x %>% filter(age_from <= 20, age_to <= 20)
  }
)

polymod_population_short <- polymod_population %>% filter(lower.age.limit <= 20)

contact_model <- fit_setting_contacts(
  contact_data_list = polymod_setting_short,
  population = polymod_population_short
)
contact_model_pred <- predict_setting_contacts(
  population = polymod_population_short,
  contact_model = contact_model,
  age_breaks = c(seq(0, 20, by = 5), Inf)
)

# check that you can specify your own population data for school and work demographics
contact_model_diff_data <- fit_setting_contacts(
  contact_data_list = polymod_setting_short,
  population = polymod_population_short,
  school_demographics = conmat_original_school_demographics,
  work_demographics = conmat_original_work_demographics
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
