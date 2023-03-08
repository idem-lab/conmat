polymod_contacts <- get_polymod_setting_data()

filter_age <- function(df, age) {
  df %>%
    dplyr::filter(age_from <= age, age_to <= age)
}

filter_setting_age <- function(list_df, age) {
  lapply(
    list_df,
    filter_age,
    age
  ) %>% new_setting_data()
}

contact_data_cut <- filter_setting_age(polymod_contacts, 10)

test_that("estimate_setting_contacts works", {
  expect_snapshot(
    estimate_setting_contacts(
      contact_data_list = contact_data_cut,
      survey_population = get_polymod_population(),
      prediction_population = get_polymod_population(),
      age_breaks = c(seq(0, 10, by = 5), Inf),
      per_capita_household_size = NULL
    )
  )
})
