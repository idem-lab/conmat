#' Prepare population data for generating an age population function
#'
#' Prepares objects for use in [get_age_population_function()].
#'
#' @param data data.frame
#' @param ... extra arguments
#' @return list of objects, `max_bound` `pop_model_bounded` `bounded_pop` `unbounded_pop` for use in [get_age_population_function()]
#' @author njtierney
#' @note internal
#' @name prepare_population_for_modelling
#' @export
prepare_population_for_modelling <- function(data, ...) {
  UseMethod("prepare_population_for_modelling")
}

#' @rdname prepare_population_for_modelling
prepare_population_for_modelling.conmat_population <- function(data, ...) {
  age_col <- age(data)
  pop_col <- population(data)
  pop_model <- data %>%
    dplyr::arrange(
      !!age_col
    ) %>%
    dplyr::mutate(
      # model based on bin midpoint
      bin_width = bin_widths(!!age_col),
      midpoint = !!age_col + bin_width / 2,
      # scaling down the population appropriately
      log_pop = log(!!pop_col / bin_width)
    )

  # find the maximum of the bounded age groups, and the populations above and
  # below
  max_bound <- max(pop_model %>%
    dplyr::pull(!!age_col))

  # filter to just the bounded age groups for fitting
  pop_model_bounded <- pop_model %>%
    dplyr::filter(
      !!age_col < max_bound
    )

  total_pop <- dplyr::pull(pop_model, !!pop_col) %>% sum()
  bounded_pop <- dplyr::pull(pop_model_bounded, !!pop_col) %>% sum()
  unbounded_pop <- total_pop - bounded_pop

  return(
    tibble::lst(
      max_bound,
      pop_model_bounded,
      bounded_pop,
      unbounded_pop
    )
  )
}

#' @name prepare_population_for_modelling
#' @param age_col column of ages
#' @param pop_col column of population,
#' @param ... extra arguments
prepare_population_for_modelling.data.frame <- function(data = data,
                                                        age_col = age_col,
                                                        pop_col = pop_col,
                                                        ...) {
  pop_model <- data %>%
    dplyr::arrange(
      {{ age_col }}
    ) %>%
    dplyr::mutate(
      # model based on bin midpoint
      bin_width = bin_widths({{ age_col }}),
      midpoint = {{ age_col }} + bin_width / 2,
      # scaling down the population appropriately
      log_pop = log({{ pop_col }} / bin_width)
    )

  # find the maximum of the bounded age groups, and the populations above and
  # below
  max_bound <- max(pop_model %>%
    dplyr::pull({{ age_col }}))

  # filter to just the bounded age groups for fitting
  pop_model_bounded <- pop_model %>%
    dplyr::filter(
      {{ age_col }} < max_bound
    )

  total_pop <- dplyr::pull(pop_model, {{ pop_col }}) %>% sum()
  bounded_pop <- dplyr::pull(pop_model_bounded, {{ pop_col }}) %>% sum()
  unbounded_pop <- total_pop - bounded_pop

  return(
    tibble::lst(
      max_bound,
      pop_model_bounded,
      bounded_pop,
      unbounded_pop
    )
  )
}

#' @title Return a function for determining population based on age, used in
#'   [get_age_population_function()].
#' @param pop_model population model data list object from
#' @return function with age input, returning population estimate
#' @author njtierney
#' @noRd
#' @note internal
return_age_population_function <- function(pop_model) {
  fit <- fit_bounded_age_groups(pop_model$pop_model_bounded)

  pred <- predict_to_long_age_ranges(pop_model, fit)

  # return a function to look up populations for integer ages
  function(age) {
    build_lookup_populations(age, pred)
  }
}

#' @title Predict log population based on age midpoints
#' @description Used within the internal function,
#'   [return_age_population_function()], ultimately for the
#'   [get_age_population_function()] function.
#' @param pop_model_bounded population data frame with columns of an age
#'   `midpoint`, and log population (`log_pop`).
#' @return model with predictions for log population
#' @author njtierney
#' @note internal
#' @noRd
fit_bounded_age_groups <- function(pop_model_bounded) {
  pop_model_bounded %>%
    with(
      smooth.spline(
        x = midpoint,
        y = log_pop,
        df = pmin(10, nrow(pop_model_bounded))
      )
    )
}

#' @title Build prediction table
#' @description Internal function used in [return_age_population_function()],
#'   ultimately for the [get_age_population_function()] function.
#' @param pop_model population model object from
#'    [prepare_population_for_modelling()].
#' @param fit model predictions
#' @return tibble with predicted population to various ages
#' @author njtierney
#' @noRd
#' @note internal
predict_to_long_age_ranges <- function(pop_model, fit) {
  max_bound <- pop_model$max_bound
  bounded_pop <- pop_model$bounded_pop
  unbounded_pop <- pop_model$unbounded_pop

  # predict to a long range of ages, to deal with upper bound
  pred <- tibble::tibble(
    age = 0:200
  ) %>%
    dplyr::mutate(
      log_pred = predict(fit, age)$y,
      pred = exp(log_pred)
    ) %>%
    # group into whether it is in the bounded or unbounded population
    dplyr::mutate(
      bounded = age < max_bound,
    ) %>%
    dplyr::group_by(
      bounded
    ) %>%
    # adjust populations within bounded ages to match totals
    dplyr::mutate(
      required_pop = ifelse(bounded, bounded_pop, unbounded_pop),
      modelled_pop = sum(pred),
      ratio = required_pop / modelled_pop,
      pred_adj = pred * ratio
    ) %>%
    dplyr::ungroup() %>%
    # adjust the unbounded region to drop off smoothly, based on the weights
    dplyr::mutate(
      # this is a weird way of getting the population of the final age bin in
      # the bounded group. Needs to happen after the previous grouped
      # reweighting step, and needs to be ungrouped now to do it.
      max_bound_pop = pred_adj[bounded][sum(bounded)],
    ) %>%
    dplyr::group_by(
      bounded
    ) %>%
    dplyr::mutate(
      # linearly extrapolate the final population group over years past the
      # upper bound. Select the number of years past such that all the excess
      # population is used up
      max_years_over = 2 * required_pop / max_bound_pop,
      years_over = pmax(0, age - max_bound),
      weight = pmax(0, 1 - years_over / max_years_over),
      weight_sum = sum(weight),
      target_weight_sum = required_pop / max_bound_pop,
      weight = weight * target_weight_sum / weight_sum,
      population = ifelse(bounded, pred_adj, max_bound_pop * weight)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(
      age,
      population
    ) %>%
    dplyr::filter(
      population > 0
    )

  pred
}

#' @title Build a population table for use in lookup
#' @description this function is used internally in the also internal function,
#'    [return_age_population_function()], ultimately for the
#'   [get_age_population_function()] function.
#' @param pred model predictions
#' @param age vector of ages
#' @return tibble with population information for age ranges
#' @author njtierney
#' @noRd
#' @note internal
build_lookup_populations <- function(age, pred) {
  tibble::tibble(
    age = age
  ) %>%
    dplyr::left_join(
      pred,
      by = "age"
    ) %>%
    dplyr::mutate(
      population = tidyr::replace_na(population, 0)
    ) %>%
    dplyr::pull(
      population
    )
}
