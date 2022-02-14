#' return an interpolating function for populations in 1y age increments
#'
#' Return an interpolating function to get populations in 1y age increments
#' from chunkier distributions produced by socialmixr::wpp_age()
#'
#' @param population population data
#' @param age_col age variable 
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' get_age_population_function(population, age_col = lower.age.limit)
#' }
#' @export
get_age_population_function <- function(population, 
                                        age_col) {
  
  # prepare population data for modelling
  pop_model <- population %>%
    dplyr::arrange(
      {{ age_col }}
    ) %>%
    dplyr::mutate(
      # model based on bin midpoint
      bin_width = bin_widths(  {{ age_col }} ),
      midpoint =  {{ age_col }} + bin_width / 2,
      # scaling down the population appropriately
      log_pop = log(population / bin_width)
    )
  
  # find the maximum of the bounded age groups, and the populations above and
  # below
  max_bound <- max(pop_model%>%
                     dplyr::pull({{ age_col }})
                     )
  
  # filter to just the bounded age groups for fitting
  pop_model_bounded <- pop_model %>%
    dplyr::filter(
      {{age_col}} < max_bound
    )
  
  total_pop <- sum(pop_model$population)
  bounded_pop <- sum(pop_model_bounded$population)
  unbounded_pop <- total_pop - bounded_pop
  
  # fit to bounded age groups  
  fit <- pop_model_bounded %>%
    with(
      smooth.spline(
        x = midpoint,
        y = log_pop,
        df = pmin(10, nrow(pop_model_bounded))
      )
    )
  
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
  
  # return a function to look up populations for integer ages
  function(age) {
    
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
  
}
