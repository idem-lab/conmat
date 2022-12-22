# need to remove the conmat_population class
fairfield <- abs_age_lga("Fairfield (C)")
class(fairfield) <- class(fairfield)[-1]

test_that("conmat_population works", {
  expect_snapshot(
    conmat_population(
      data = fairfield,
      age = lower.age.limit,
      population = population
    )
  )
})

# TODO
# Need to add some defensive programming stuff
# Need to detect when you try and input a conmat population again
