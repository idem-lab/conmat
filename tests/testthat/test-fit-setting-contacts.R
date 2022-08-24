polymod_setting_data <- get_polymod_setting_data()
polymod_population <- get_polymod_population()

test_that("fit_single_contact_model works", {
  expect_silent(
    contact_model <- fit_single_contact_model(
      contact_data = polymod_setting_data$home,
      population = polymod_population
    )
  )
})

contact_model <- fit_setting_contacts(
  contact_data_list = polymod_setting_data,
  population = polymod_population
)

test_that("fit_setting_contacts works", {
  expect_silent(
    fit_setting_contacts(
      contact_data_list = polymod_setting_data,
      population = polymod_population
    )
  )
})

test_that("predict_setting_contacts works", {
  expect_silent(
  contact_model_pred <- predict_setting_contacts(
    population = polymod_population,
    contact_model = contact_model,
    age_breaks = c(seq(0, 75, by = 5), Inf)
  )
  )
})