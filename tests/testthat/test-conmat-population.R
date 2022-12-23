# need to remove the conmat_population class
fairfield <- as.data.frame(abs_age_lga("Fairfield (C)"))

test_that("conmat_population works", {
  expect_snapshot(
    conmat_population(
      data = fairfield,
      age = lower.age.limit,
      population = population
    )
  )
  
})

test_that("as_conmat_population works", {
  expect_snapshot(
    as_conmat_population(
      data = fairfield,
      age = lower.age.limit,
      population = population
    )
  )
})

# TODO
# Need to add some defensive programming stuff
# Need to detect when you try and input a conmat population again
