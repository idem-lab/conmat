perth <- abs_age_lga("Perth (C)")
perth_hh <- get_abs_per_capita_household_size(lga = "Perth (C)")
age_breaks_0_75 <- c(seq(0, 75, by = 5), Inf)
age_breaks_0_85 <- c(seq(0, 85, by = 5), Inf)

perth_contact <- extrapolate_polymod(
  perth,
  per_capita_household_size = perth_hh
)

perth_ngm_lga <- generate_ngm(
  perth,
  age_breaks = age_breaks_0_75,
  per_capita_household_size = perth_hh,
  R_target = 1.5
)

perth_ngm <- generate_ngm(
  perth_contact,
  age_breaks = age_breaks_0_75,
  R_target = 1.5
)

perth_ngm_oz <- generate_ngm_oz(
  lga_name = "Perth (C)",
  age_breaks = age_breaks_0_75,
  R_target = 1.5
)

test_that("the three variants of the generate_ngm produce the same result", {
  expect_true(all.equal(perth_ngm_lga, perth_ngm))
  expect_true(all.equal(perth_ngm_lga, perth_ngm_oz))
  expect_true(all.equal(perth_ngm_oz, perth_ngm))
})

test_that("NGMs from each generate_ngm type return the same object", {
  expect_snapshot(
    perth_ngm_lga
  )
  expect_snapshot(
    perth_ngm
  )
  expect_snapshot(
    perth_ngm_oz
  )
})

test_that("generate_ngm fails when given wrong age breaks", {
  expect_snapshot(
    error = TRUE,
    generate_ngm(
      perth_contact,
      age_breaks = age_breaks_0_85,
      R_target = 1.5
    )
  )
})
