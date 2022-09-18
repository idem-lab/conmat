test_that("new_population works", {
  expect_snapshot_output(
    new_population(
      data = abs_age_lga("Fairfield (C)"),
      age = lower.age.limit,
      population = population
      )
  )
})
