test_that("abs_abbreviate_states() works", {
  expect_snapshot(abs_abbreviate_states("New South Wales"))
})

test_that("abs_unabbreviate_states() works", {
  expect_snapshot(abs_unabbreviate_states("NSW"))
})
