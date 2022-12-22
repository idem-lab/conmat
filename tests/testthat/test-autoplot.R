
test_that("autoplot works", {
  skip_on_cran()
  skip_on_ci()
  set.seed(2021 - 10 - 4)
  synthetic_settings_5y_fairfield <- extrapolate_polymod(
    age_breaks = seq(0, 15, by = 5),
    population = abs_age_lga("Fairfield (C)")
  )
  autoplot_all_settings <- autoplot(synthetic_settings_5y_fairfield)
  vdiffr::expect_doppelganger("autoplot-all-settinge", autoplot_all_settings)

  autoplot_work <- autoplot(object = synthetic_settings_5y_fairfield$work, title = "Work")
  vdiffr::expect_doppelganger("autoplot-single-setting", autoplot_all_settings)
})
