world_data <- socialmixr::wpp_age()

test_that("age_population works", {
  expect_snapshot(
    # Tidy data for multiple locations across different years
    age_population(
      data = world_data,
      location_col = country,
      location = c("Asia", "Afghanistan"),
      age_col = lower.age.limit,
      year_col = year,
      year = c(2010:2020)
    )
  )

  expect_snapshot(
    # Tidy data for a given location irrespective of year
    age_population(
      data = world_data,
      location_col = country,
      location = "Afghanistan",
      age_col = lower.age.limit
    )
  )
})
