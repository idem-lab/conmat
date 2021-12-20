get_per_capita_household_size(lga = "Fairfield (C)")
get_per_capita_household_size(lga = "Botany Bay (C)")

all_household_lgas <- unique(abs_household_lga$lga)

all_household_lgas
library(purrr)

# instead of writing it out for each of the household LGAs
# we can use purrr
    # get_per_capita_household_size(lga = all_household_lgas[1])
    # get_per_capita_household_size(lga = all_household_lgas[2])
    # get_per_capita_household_size(lga = all_household_lgas[3])
    # get_per_capita_household_size(lga = all_household_lgas[4])

# but this errors out when we have an LGA that doesn't work
household_per_capita_runs <- map(
  .x = all_household_lgas,
  .f = ~get_per_capita_household_size(lga = .x)
)

# use `safely` function from purrr to capture the errors
safe_get_per_capita_household_size <- safely(get_per_capita_household_size)

get_per_capita_household_size(lga = "Fairfield (C)")
safe_get_per_capita_household_size(lga = "Fairfield (C)")
safe_get_per_capita_household_size(lga = "Botany Bay (C)")

household_per_capita_runs <- map(
  .x = all_household_lgas,
  .f = ~safe_get_per_capita_household_size(lga = .x)
)

household_per_capita_runs[[1]]
household_per_capita_runs[[2]]

t_household_per_capita_runs <- transpose(household_per_capita_runs)

# count or test if the result is all not NULL
sum(map_lgl(t_household_per_capita_runs$result, is.null))

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})
