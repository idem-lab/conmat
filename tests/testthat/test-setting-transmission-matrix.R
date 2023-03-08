age_breaks_0_80_plus <- c(seq(0, 80, by = 10), Inf)
one_05 <- matrix(0.05, nrow = 9, ncol = 9)

test_that("transmission_probability_matrix works", {
  expect_snapshot(
    transmission_probability_matrix(
      home = one_05,
      work = one_05,
      age_breaks = age_breaks_0_80_plus
    )
  )

  expect_snapshot(
    transmission_probability_matrix(
      one_05,
      one_05,
      age_breaks = age_breaks_0_80_plus
    )
  )
})
