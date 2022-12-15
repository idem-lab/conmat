

test_that("refactored code works", {
  expect_equal(abs_per_capita_household_size_state("NSW"), get_per_capita_household_size("NSW"))
})

test_that("refactored code works with lga", {
  expect_equal(abs_per_capita_household_size_lga(unique(abs_lga_lookup$lga)[1]),
               get_per_capita_household_size(lga=unique(abs_lga_lookup$lga)[1]))
})


test_that("errors when given incorrect state", {
  expect_error(abs_per_capita_household_size_state("NSA"))
})


test_that("errors when given incorrect lga", {
  expect_error(abs_per_capita_household_size_lga("Fairfield"))
})
