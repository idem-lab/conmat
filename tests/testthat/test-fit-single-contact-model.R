library(dplyr)
contact_data <- get_polymod_contact_data("all")  %>% 
  filter(age_from <= 10,
         age_to <= 10)

population <- get_polymod_population() %>% 
  filter(lower.age.limit <= 10)

m_all <- fit_single_contact_model(
  contact_data = contact_data,
  population = population
)


test_that("Model fits", {
  expect_s3_class(m_all, "bam")
})

test_that("Model coefficients are the same", {
  expect_snapshot(names(m_all$coefficients))
})
