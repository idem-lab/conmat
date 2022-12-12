library(dplyr)
contact_data <- get_polymod_contact_data("all")  %>% 
  filter(age_from <= 20,
         age_to <= 20)

population <- get_polymod_population() %>% 
  filter(lower.age.limit <= 20)

m_all <- fit_single_contact_model(
  contact_data = contact_data,
  population = population
)

m_all_not_sym <- fit_single_contact_model(
  contact_data = contact_data,
  population = population,
  symmetrical = FALSE
)

test_that("Model returns bam model", {
  expect_s3_class(m_all, "bam")
  expect_s3_class(m_all_not_sym, "bam")
})

test_that("Model coefficients are the same", {
  expect_snapshot(names(m_all$coefficients))
  expect_snapshot(names(m_all_not_sym$coefficients))
})

test_that("Model fits", {
  expect_no_warning(
    fit_single_contact_model(
      contact_data = contact_data,
      population = population,
      symmetrical = FALSE
    )
  )
  expect_no_warning(
    fit_single_contact_model(
      contact_data = contact_data,
      population = population,
    )
  )
})