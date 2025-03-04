test_that("Partial prediction functions work for a single model setting", {
  skip_on_ci()
  # just partial effects for a single setting
  expect_no_failure({
    partials_home <- partial_effects(
      polymod_setting_models$home,
      ages = 1:99
    )
  })

  expect_snapshot(partials_home)

  expect_s3_class(partials_home, "partial_predictions")

  gg_partials_home <- autoplot(partials_home)
  vdiffr::expect_doppelganger("gg_partials_home", gg_partials_home)
})

test_that("Partial prediction functions work for all model settings", {
  skip_on_ci()
  # partial effects for all settings
  expect_no_failure({
    partials_setting <- partial_effects(
      polymod_setting_models,
      ages = 1:99
    )
  })

  expect_snapshot(partials_setting)

  expect_s3_class(partials_setting, "setting_partial_predictions")

  gg_partials_setting <- autoplot(partials_setting)

  vdiffr::expect_doppelganger("gg_partials_setting", gg_partials_setting)
})

test_that("Partial prediction sum functions work for a single model setting", {
  skip_on_ci()
  # Summed up partial effects (y-hat) for a single setting
  expect_no_failure({
    partials_summed_home <- partial_effects_sum(
      polymod_setting_models$home,
      ages = 1:99
    )
  })

  expect_snapshot(partials_summed_home)

  expect_s3_class(partials_summed_home, "partial_predictions_sum")

  gg_partials_sum_home <- autoplot(partials_summed_home)

  vdiffr::expect_doppelganger("gg_partials_sum_home", gg_partials_sum_home)
})

test_that("Partial prediction sum functions work for a single model setting", {
  skip_on_ci()
  # summed up partial effects (y-hat) for all settings
  expect_no_failure({
    partials_summed_setting <- partial_effects_sum(
      polymod_setting_models,
      ages = 1:99
    )
  })

  expect_snapshot(partials_summed_setting)

  expect_s3_class(partials_summed_setting, "setting_partial_predictions_sum")

  gg_partials_sum_setting <- autoplot(partials_summed_setting)

  vdiffr::expect_doppelganger(
    "gg_partials_sum_setting",
    gg_partials_sum_setting
  )
})

partial_effects(polymod_setting_models$home, ages = 1:99) |> autoplot()

partial_effects(polymod_setting_models, ages = 1:99) |> autoplot()

pe_standard <- partial_effects(polymod_setting_models, ages = 1:99)

pe_alt <- purrr::map_dfr(
  .x = polymod_setting_models,
  .f = partial_effects,
  ages = 1:99,
  .id = "setting"
)

pe_standard
pe_alt

all.equal(pe_standard, pe_alt)

class(pe_standard)
autoplot(pe_standard)


# ggplot(aes(x = age_from,
#            y = age_to,
#            fill = value)) +
# geom_tile() +
# facet_grid(setting~pred,
#            switch = "y") +
# coord_fixed() +
# labs(fill = place)

gg_age_terms_settings(pe_standard)
gg_age_terms_settings(pe_alt)

# age_predictions_all_settings |>
#   tidyr::pivot_longer(
#     dplyr::starts_with("pred"),
#     names_to = "pred",
#     values_to = "value",
#     names_prefix = "pred_"
#   ) |>
#   dplyr::select(age_from,
#                 age_to,
#                 value,
#                 pred,
#                 setting)

partial_effects_sum(polymod_setting_models, ages = 1:99)

alt_partial_sum <- purrr::map_dfr(
  .x = polymod_setting_models,
  .f = partial_effects_sum,
  ages = 1:99,
  .id = "setting"
)

current_partial_sum <- partial_effects_sum(polymod_setting_models, ages = 1:99)

gg_age_partial_sum(alt_partial_sum)
gg_age_partial_sum(alt_partial_sum) + facet_wrap(~setting)
gg_age_partial_sum(current_partial_sum)
gg_age_partial_sum(current_partial_sum) + facet_wrap(~setting)


current_partial_effects <- partial_effects(polymod_setting_models, ages = 1:99)
current_partial_effects
alt_partial_effects <- purrr::map_dfr(
  polymod_setting_models,
  partial_effects,
  ages = 1:99,
  .id = "setting"
)

current_partial_effects
alt_partial_effects

waldo::compare(
  current_partial_effects,
  alt_partial_effects
)

all.equal(
  current_partial_effects,
  alt_partial_effects
)

alt_partial_effects |>
  named_group_split(setting) |>
  purrr::map_dfr(add_age_partial_sum, .id = "setting") |>
  gg_age_partial_sum() +
  facet_wrap(~setting)


partials_summed_home <- partial_effects_sum(
  polymod_setting_models$home,
  ages = 1:99
)

autoplot(partials_summed_home)

gg_age_partial_sum

current_partial_effects_sum <- partial_effects_sum(
  polymod_setting_models,
  ages = 1:99
)

iris %>%
  group_by(Species) %>%
  summarise(across(
    starts_with("Sepal"),
    list(mean = mean, sd = sd),
    .names = "{.col}.{.fn}"
  ))
#> #

current_partial_effects_sum |>
  group_by(setting) |>
  summarise(
    minimum = min(gam_total_term),
    q25 = quantile(gam_total_term, probs = 0.25),
    med = median(gam_total_term),
    q75 = quantile(gam_total_term, probs = 0.75),
    maximum = max(gam_total_term),
    average = mean(gam_total_term),
    .groups = "drop"
  )

# ggplot(current_partial_effects_sum,
#        aes(x = setting,
#            y = gam_total_term)) +
#   geom_boxplot() +
#   facet_wrap(~setting,
#              scales = "free")

gg_age_partial_sum_setting(current_partial_effects_sum)

current_partial_effects_sum |>
  filter(setting == "work") |>
  ggplot(
    aes(
      x = age_from,
      y = age_to,
      fill = gam_total_term
    )
  ) +
  geom_tile() +
  scale_fill_viridis_c(trans = "sqrt")
facet_wrap(~setting)

partial_effects_sum(
  polymod_setting_models$home,
  ages = 1:99
) |>
  autoplot()

partial_effects(
  polymod_setting_models$other,
  ages = 1:99
) |>
  autoplot()
