test_that("abbreviate_states() works", {
  expect_snapshot(abbreviate_states("New South Wales"))
})

test_that("unabbreviate_states() works", {
  expect_snapshot(unabbreviate_states("NSW"))
})
