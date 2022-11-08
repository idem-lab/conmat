
ngm_fairfield_85_plus <- generate_ngm(
  lga_name = "Fairfield (C)",
  age_breaks = c(seq(0, 85, by = 5), Inf),
  R_target = 1.5
)

ngm_fairfield_80_plus <- generate_ngm(
  lga_name = "Fairfield (C)",
  age_breaks = c(seq(0, 80, by = 5), Inf),
  R_target = 1.5
)



test_that("check_dimensions() returns nothing when compatible dimensions", {

  

  
  expect_silent(check_dimensions(ngm_fairfield_80_plus,
                                         vaccination_effect_example_data))
})

test_that("check_dimensions() returns error", {
  

  expect_snapshot_error(check_dimensions(ngm_fairfield_85_plus,
                                  vaccination_effect_example_data))
})

test_that("apply_vaccination gives error when incompatible dimensions present", {

 expect_snapshot_error(apply_vaccination(
    ngm = ngm_fairfield_85_plus,
    data = vaccination_effect_example_data,
    coverage_col = coverage,
    acquisition_col = acquisition,
    transmission_col = transmission
  ))
  
})

# ngm_nsw_vacc <- apply_vaccination(
#   ngm = ngm_fairfield_80_plus,
#   data = vaccination_effect_example_data,
#   coverage_col = coverage,
#   acquisition_col = acquisition,
#   transmission_col = transmission
# )