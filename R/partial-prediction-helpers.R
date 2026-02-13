#' Create partial predictions and partial prediction plots.
#'
#' Partial predictions allow you to explore and understand the impact of each
#'   of the covariates used in the conmat GAM model. See 'Details' for more
#'   information.
#'
#' @details
#'
#' Partial predictive plots give a visual representation of the effect of each
#'   covariate on the model, or (equivalently) the effect of each setting on
#'   the total contact matrix. Positive values indicate more contacts in that
#'   region of the matrix compared to the null case, while negative values
#'   indicate less. Essentially, they represent the change in outcome variable
#'   on the __model scale__ with a unit change in input variable.
#'
#' Scales are not comparable _across_ settings, as each setting has it's own
#'   intercept term which is not accounted for in partial effects.
#'
#' @param model A fitted contact model, with class `contact_model` (from [fit_single_contact_model()], or a simple element from list output of [fit_setting_contacts()]), e.g. `polymod_setting_models$home`. Or, class `setting_contact_model` - a list of fitted contact models (from [fit_setting_contacts()])), e.g. `polymod_setting_models`.
#' @param ages vector of integer ages.
#' @param ... extra arguments. Currently not used.
#' @return data frame with 20 columns plus n rows based on expand.grid
#'   combination of ages. Contains transformed coefficients from ages.
#' @name partial-prediction
#' @examples
#' partials_home <- partial_effects(
#'   polymod_setting_models$home, # Do for all models by omitting $home
#'   ages = 1:99
#'   )
#' @export
partial_effects <- function(model, ages, ...) {
  UseMethod("partial_effects")
}

#' @rdname partial-prediction
#' @export
partial_effects.contact_model <- function(model, ages, ...) {
  age_grid <- create_age_grid(ages = ages)
  term_names <- extract_term_names(model)
  term_var_names <- clean_term_names(term_names)

  age_predictions <- predict_individual_terms(
    age_grid = age_grid,
    model = model,
    term_names = term_names,
    term_var_names = term_var_names
  )

  age_predictions_long <- pivot_longer_age_preds(age_predictions)

  structure(
    age_predictions_long,
    class = c("partial_predictions", class(age_predictions_long))
  )
}


#' @rdname partial-prediction
#' @export
partial_effects.setting_contact_model <- function(model, ages, ...) {
  age_predictions_setting_long <- purrr::map_dfr(
    model,
    partial_effects,
    ages = ages,
    .id = "setting"
  )

  structure(
    age_predictions_setting_long,
    class = c(
      "setting_partial_predictions",
      class(age_predictions_setting_long)
    )
  )
}

#' Create partial predictive plots for a set of fitted models.
#'
#' These helper functions exist to make it easier to explore and understand the
#'   impact of each of the covariates used in the conmat GAM model.
#'
#' @details
#'
#' Partial predictive plots give a visual representation of the effect of each
#'   covariate on the model, or (equivalently) the effect of each setting on
#'   the total contact matrix. Positive values indicate more contacts in that
#'   region of the matrix compared to the null case, while negative values
#'   indicate less.
#'
#' Scales are not comparable _across_ settings, as each setting has it's own
#'   intercept term, which is not accounted for in partial effects.
#'
#' @param model A fitted model, or list of fitted models
#' @param ages vector of integer ages
#' @param ... dots for future extension. Currently not used.
#' @return data frame with 3 columns plus n rows based on expand.grid
#'   combination of ages. The column `gam_total_term` is the sum over
#'   the coefficients for that age bracket.
#' @name partial-prediction-sum
#' @examples
#' # summed up partial effects (y-hat) for all settings
#' partials_summed_setting <- partial_effects_sum(
#'     polymod_setting_models, # can also do for one setting with $home
#'     ages = 1:99
#'   )
#' autoplot(partials_summed_setting)
#' @export
partial_effects_sum <- function(model, ages, ...) {
  UseMethod("partial_effects_sum")
}

#' @rdname partial-prediction-sum
#' @export
partial_effects_sum.contact_model <- function(model, ages, ...) {
  age_predictions_long <- partial_effects(model, ages)
  partial_sums <- add_age_partial_sum(age_predictions_long)
  structure(
    partial_sums,
    class = c("partial_predictions_sum", class(partial_sums))
  )
}

#' @rdname autoplot-conmat-partial
#' @export
autoplot.partial_predictions_sum <- function(object, ...) {
  gg_age_partial_sum(object) +
    scale_fill_viridis_c(
      name = "log\ncontacts"
    )
}

#' @rdname partial-prediction
#' @export
partial_effects_sum.setting_contact_model <- function(model, ages, ...) {
  setting_partial_sums <- purrr::map_dfr(
    model,
    partial_effects_sum,
    ages = ages,
    .id = "setting"
  )

  structure(
    setting_partial_sums,
    class = c("setting_partial_predictions_sum", class(setting_partial_sums))
  )
}

#' @rdname autoplot-conmat-partial
#' @export
autoplot.setting_partial_predictions_sum <- function(object, ...) {
  facet_age_plot <- function(data, place) {
    data |>
      dplyr::filter(setting == place) |>
      ggplot(aes(x = age_from, y = age_to, fill = gam_total_term)) +
      geom_tile() +
      facet_grid(~setting, switch = "y") +
      coord_fixed() +
      labs(fill = place) +
      theme_minimal()
  }

  p_home <- facet_age_plot(object, "home") +
    scale_fill_viridis_c()
  p_work <- facet_age_plot(object, "work") +
    scale_fill_viridis_c(option = "rocket")
  p_school <- facet_age_plot(object, "school") +
    scale_fill_viridis_c(option = "plasma")
  p_other <- facet_age_plot(object, "other") +
    scale_fill_viridis_c(option = "mako")

  patchwork::wrap_plots(
    p_home,
    p_work,
    p_school,
    p_other,
    nrow = 2
  )
}

# TODO
# add autoplot method for summed partials settings?

#' Plot partial predictive plots using ggplot2
#'
#' @param object An object with partial predictions from [partial_effects()].
#' @param ...	 Other arguments passed on. Currently not used.
#' @return a ggplot visualisation of partial effects
#' @name autoplot-conmat-partial
#' @export
autoplot.partial_predictions <- function(object, ...) {
  gg_age_partial_pred_long(object)
}

#' @rdname autoplot-conmat-partial
#' @export
autoplot.setting_partial_predictions <- function(object, ...) {
  gg_age_terms_settings(object)
}


create_age_grid <- function(ages) {
  age_grid <- expand.grid(
    age_from = ages,
    age_to = ages
  ) |>
    tibble::as_tibble() |>
    # prepare the age data so it has all the right column names
    # that are used inside of `fit_single_contact_model()`
    # conmat::add_symmetrical_features() |>
    add_symmetrical_features() |>
    # this ^^^ does the same as the commented part below:
    # dplyr::mutate(
    #   gam_age_offdiag = abs(age_from - age_to),
    #   gam_age_offdiag_2 = abs(age_from - age_to)^2,
    #   gam_age_diag_prod = abs(age_from * age_to),
    #   gam_age_diag_sum = abs(age_from + age_to),
    #   gam_age_pmax = pmax(age_from, age_to),
    #   gam_age_pmin = pmin(age_from, age_to)
    # ) |>
    # This is to add the school_probability and work_probability columns
    # that are used inside fit_single_contact_model() when fitting the model.
    # conmat::add_modelling_features()
    add_modelling_features()

  age_grid
}

#' Helper function to extract term names out of GAM fitted model object.
#'
#' @param model fitted model object for one single conmat model setting. E.g., the
#'   home setting.
#' @return character vector of term names
#' @noRd
#' @examples
#' extract_term_names(polymod_setting_models$home)
extract_term_names <- function(model) {
  coef_names <- names(model$coefficients) |>
    stringr::str_remove_all("\\.[^.]*$") |>
    unique() |>
    stringr::str_subset("^s\\(")

  coef_names
}

#' Clean up GAM term names for use in plotting
#' @param term_names character vector of model term names (e.g., 's(offdiag)').
#' @return names like "offdiag", instead of "s(offdiag)"
#' @noRd
#' @examples
#' extract_term_names(polymod_setting_models$home) |> clean_term_names()
clean_term_names <- function(term_names) {
  term_names |>
    stringr::str_remove_all("^s\\(gam_age_") |>
    stringr::str_remove_all(stringr::fixed(")"))
}

#'
#' @param age_grid grid of ages from `create_age_grid()`
#' @param model model fitted object from conmat, e.g.,
#'   `polymod_setting_models$home`.
#' @param term_names terms from model extracted with `extract_term_names()`.
#' @param term_var_names Cleaned up term names from model used with
#'   `clean_term_names()`.
#' @return Data frame containing predicted values added to output of
#'   `create_age_grid()`.
#' @noRd
predict_individual_terms <- function(
  age_grid,
  model,
  term_names,
  term_var_names
) {
  predicted_term <- function(age_grid, model, term_name, term_var_name) {
    predict(
      object = model,
      newdata = age_grid,
      type = "terms",
      terms = term_name
    ) |>
      tibble::as_tibble() |>
      stats::setNames(glue::glue("pred_{term_var_name}"))
  }

  all_predicted_terms <- purrr::map2_dfc(
    .x = term_names,
    .y = term_var_names,
    .f = function(.x, .y) {
      predicted_term(
        age_grid = age_grid,
        model = model,
        term_name = .x,
        term_var_name = .y
      )
    }
  )

  dplyr::bind_cols(age_grid, all_predicted_terms)
}

#' Plot all age terms across all settings
#' @param age_predictions_all_settings output from mapped
#'   `predict_individual_terms`.
#' @return ggplot objects
#' @importFrom ggplot2 ggplot aes geom_tile facet_grid coord_fixed scale_fill_viridis_c theme_minimal facet_wrap labs
#' @noRd
gg_age_terms_settings <- function(age_predictions_all_settings) {
  pred_all_setting_longer <- age_predictions_all_settings |>
    dplyr::select(age_from, age_to, value, pred, setting)

  facet_age_plot <- function(data, place) {
    data |>
      dplyr::filter(setting == place) |>
      ggplot(aes(x = age_from, y = age_to, fill = value)) +
      geom_tile() +
      facet_grid(setting ~ pred, switch = "y") +
      coord_fixed() +
      labs(fill = place)
  }

  p_home <- facet_age_plot(pred_all_setting_longer, "home") +
    scale_fill_viridis_c()
  p_work <- facet_age_plot(pred_all_setting_longer, "work") +
    scale_fill_viridis_c(option = "rocket")
  p_school <- facet_age_plot(pred_all_setting_longer, "school") +
    scale_fill_viridis_c(option = "plasma")
  p_other <- facet_age_plot(pred_all_setting_longer, "other") +
    scale_fill_viridis_c(option = "mako")

  patchwork::wrap_plots(
    p_home,
    p_work,
    p_school,
    p_other,
    nrow = 4
  )
}

#' @param age_predictions age predictions
#' @return data frame
#' @noRd
pivot_longer_age_preds <- function(age_predictions) {
  age_predictions |>
    tidyr::pivot_longer(
      dplyr::starts_with("pred"),
      names_to = "pred",
      values_to = "value",
      names_prefix = "pred_"
    )
}

#' @param age_predictions_long age prediction data frame
#' @return ggplot object
#' @noRd
gg_age_partial_pred_long <- function(age_predictions_long) {
  facet_names <- data.frame(
    pred = c("diag_prod", "diag_sum", "offdiag", "offdiag_2", "pmax", "pmin"),
    math_name = c(
      "i x j",
      "i + j",
      "|i - j|",
      "|i - j|^2^",
      "max(i, j)",
      "min(i, j)"
    )
  )

  age_predictions_long %>%
    dplyr::left_join(facet_names, by = dplyr::join_by("pred")) %>%
    ggplot(
      aes(
        x = age_from,
        y = age_to,
        group = math_name,
        fill = value
      )
    ) +
    facet_wrap(~math_name, ncol = 3) +
    geom_tile() +
    scale_fill_viridis_c(
      name = "log\ncontacts"
    ) +
    theme_minimal()
}

#' @param age_predictions_long age prediction data
#' @return data.frame
#' @noRd
add_age_partial_sum <- function(age_predictions_long) {
  age_partial_sum <- age_predictions_long |>
    dplyr::group_by(age_from, age_to) |>
    dplyr::summarise(
      gam_total_term = sum(value),
      .groups = "drop"
    )

  age_partial_sum
}

#' @param age_predictions_long_sum age prediction data
#' @return ggplot object
#' @noRd
gg_age_partial_sum <- function(age_predictions_long_sum) {
  ggplot(
    data = age_predictions_long_sum,
    aes(
      x = age_from,
      y = age_to,
      fill = gam_total_term
    )
  ) +
    geom_tile() +
    theme_minimal()
}

gg_age_partial_sum_setting <- function(age_predictions_long_sum_setting) {
  facet_age_plot <- function(data, place) {
    data |>
      dplyr::filter(setting == place) |>
      gg_age_partial_sum()
  }

  p_home <- facet_age_plot(age_predictions_long_sum_setting, "home") +
    scale_fill_viridis_c(name = "home")
  p_work <- facet_age_plot(age_predictions_long_sum_setting, "work") +
    scale_fill_viridis_c(option = "rocket", name = "work")
  p_school <- facet_age_plot(age_predictions_long_sum_setting, "school") +
    scale_fill_viridis_c(option = "plasma", name = "school")
  p_other <- facet_age_plot(age_predictions_long_sum_setting, "other") +
    scale_fill_viridis_c(option = "mako", name = "other")

  patchwork::wrap_plots(
    p_home,
    p_work,
    p_school,
    p_other,
    nrow = 4
  )
}
