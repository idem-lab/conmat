#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param ages
#' @return
#' @author njtierney
#' @export
create_age_grid <- function(ages) {
  ## TODO
  ## Wrap this up into a function that generates an age grid data frame
  ## with all the terms needed to fit a conmat model
  ## (from `fit_single_contact_model.R`)
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
  
  
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param fit_home
#' @return
#' @author njtierney
#' @export
extract_term_names <- function(fit_home) {
  
  coef_names <- names(fit_home$coefficients) |>
    stringr::str_remove_all("\\.[^.]*$") |>
    unique() |>
    stringr::str_subset("^s\\(")
  
  coef_names
  
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param term_names
#' @return
#' @author njtierney
#' @export
clean_term_names <- function(term_names) {
  
  term_names |>
    stringr::str_remove_all("^s\\(gam_age_") |>
    stringr::str_remove_all("\\)")
  
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param age_grid
#' @param term_names
#' @param term_var_names
#' @return
#' @author njtierney
#' @export
predict_individual_terms <- function(age_grid, fit, term_names, term_var_names) {
  
  predicted_term <- function(age_grid, fit, term_name, term_var_name){
    predict(object = fit,
            newdata = age_grid,
            type = "terms",
            terms = term_name) |>
      tibble::as_tibble() |>
      setNames(glue::glue("pred_{term_var_name}"))
  }
  
  all_predicted_terms <- purrr::map2_dfc(
    .x = term_names,
    .y = term_var_names,
    .f = function(.x, .y){
      predicted_term(age_grid = age_grid,
                     fit = fit,
                     term_name = .x,
                     term_var_name = .y)
    }
  )
  
  dplyr::bind_cols(age_grid, all_predicted_terms)
  
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param age_predictions_all_settings
#' @return
#' @author njtierney
#' @importFrom ggplot2 ggplot aes geom_tile facet_grid coord_fixed scale_fill_viridis_c theme_minimal facet_wrap
#' @export
gg_age_terms_settings <- function(age_predictions_all_settings) {
  
  pred_all_setting_longer <- age_predictions_all_settings |>
    tidyr::pivot_longer(
      dplyr::starts_with("pred"),
      names_to = "pred",
      values_to = "value",
      names_prefix = "pred_"
    ) |>
    dplyr::select(age_from,
           age_to,
           value,
           pred,
           setting)
  
  facet_age_plot <- function(data, place){
    data |>
      dplyr::filter(setting == place) |>
      ggplot(aes(x = age_from,
                 y = age_to,
                 fill = value)) +
      geom_tile() +
      facet_grid(setting~pred,
                 switch = "y") +
      coord_fixed()
    
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

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param age_predictions
#' @return
#' @author njtierney
#' @export
pivot_longer_age_preds <- function(age_predictions) {
  age_predictions |>
    tidyr::pivot_longer(
      dplyr::starts_with("pred"),
      names_to = "pred",
      values_to = "value",
      names_prefix = "pred_"
    )
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param age_predictions_long
#' @return
#' @author njtierney
#' @export
gg_age_partial_pred_long <- function(age_predictions_long) {

  facet_names <- data.frame(
    pred = c("diag_prod", "diag_sum", "offdiag", "offdiag_2", "pmax", "pmin"),
    math_name = c("i x j", "i + j", "|i - j|", "|i - j|²", "max(i, j)", "min(i, j)")
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

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param age_predictions_long
#' @return
#' @author njtierney
#' @export
add_age_partial_sum <- function(age_predictions_long) {
  
  age_partial_sum <- age_predictions_long |>
    dplyr::group_by(age_from,
             age_to) |>
    dplyr::summarise(
      gam_total_term = exp(sum(value)),
      .groups = "drop"
    )
  
  age_partial_sum
  
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param age_predictions_long_sum
#' @return
#' @author njtierney
#' @export
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
    scale_fill_viridis_c(
      name = "Num.\ncontacts",
      option = "magma",
      limits = c(0, 12)
    ) +
    theme_minimal()
  
}

