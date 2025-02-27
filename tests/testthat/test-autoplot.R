fairfield <- abs_age_lga("Fairfield (C)")

age_break_0_15_plus <- c(seq(0, 15, by = 5), Inf)

fairfield_contact <- extrapolate_polymod(
  population = fairfield,
  age_breaks = age_break_0_15_plus
)

fairfield_ngm <- generate_ngm(
  fairfield_contact,
  age_breaks = age_break_0_15_plus,
  R_target = 1.5
)

# example only
vaccination_effect_example_data_0_15 <- tibble::tribble(
  ~age_band,
  ~coverage,
  ~acquisition,
  ~transmission,
  "0-4",
  0,
  0,
  0,
  "5-11",
  0.782088952510108,
  0.583348020448795,
  0.254242125175986,
  "12-15",
  0.997143279318327,
  0.630736845626691,
  0.29520141450591,
  "15+",
  0.998557451078776,
  0.843558083086652,
  0.555937989293065
)

fairfield_vaccination <- apply_vaccination(
  ngm = fairfield_ngm,
  data = vaccination_effect_example_data_0_15,
  coverage_col = coverage,
  acquisition_col = acquisition,
  transmission_col = transmission
)

transmission_matrices_0_15 <- get_setting_transmission_matrices(
  age_breaks = age_break_0_15_plus
)

# autoplot.conmat_age_matrix
test_that("autoplot works for age matrix", {
  skip_on_cran()
  skip_on_ci()
  set.seed(2023 - 1 - 17)
  autoplot_work <- autoplot(
    object = fairfield_contact$work,
    title = "Work"
  )
  vdiffr::expect_doppelganger("autoplot-single-setting", autoplot_work)
})

# autoplot.conmat_setting_prediction_matrix
test_that("autoplot works for setting prediction matrix", {
  skip_on_cran()
  skip_on_ci()
  set.seed(2023 - 1 - 17)
  autoplot_all_settings <- autoplot(fairfield_contact)
  vdiffr::expect_doppelganger("autoplot-all-settinge", autoplot_all_settings)
})

# autoplot.ngm_setting_matrix
test_that("autoplot works for NGMs", {
  skip_on_cran()
  skip_on_ci()
  set.seed(2023 - 1 - 17)
  autoplot_ngm <- autoplot(object = fairfield_ngm)
  vdiffr::expect_doppelganger("autoplot-ngm", autoplot_ngm)
})

# autoplot.setting_vaccination_matrix
test_that("autoplot works for vaccination setting matrices", {
  skip_on_cran()
  skip_on_ci()
  set.seed(2023 - 1 - 17)
  autoplot_vaccination <- autoplot(object = fairfield_vaccination)
  vdiffr::expect_doppelganger("autoplot-vaccination", autoplot_vaccination)
})

# autoplot.transmission_probability_matrix
test_that("autoplot works for transmission probability matrices", {
  skip_on_cran()
  skip_on_ci()
  set.seed(2023 - 1 - 17)
  autoplot_transmission <- autoplot(object = transmission_matrices_0_15)
  vdiffr::expect_doppelganger("autoplot-", autoplot_transmission)
})
