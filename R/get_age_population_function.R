#' @title Return an interpolating function for populations in 1y age increments
#'
#' @description This function returns an interpolating function to get
#'   populations in 1y age increments from chunkier distributions produced by
#'   `socialmixr::wpp_age()`.
#'
#' @param data dataset containing information on population of a given 
#'   age/age group
#' @param age_col bare variable name for the column with age information 
#' @param pop_col bare variable name for the column with population information
#' 
#' @details The function first prepares the data to fit a smoothing spline to
#'  the data for ages below the maximum age. It arranges the data by the lower 
#'  limit of the age group to obtain the bin width/differences of the lower 
#'  age limits. The mid point of the bin width is later added to the ages and 
#'  the population is scaled as per the bin widths. The maximum age is later 
#'  obtained and the populations for different above and below are filtered out
#'  along with the sum of populations with and without maximum age. A cubic 
#'  smoothing spline is then fitted to the data for ages below the maximum with 
#'  predictor variable as the ages with the mid point of the bins added to it 
#'  where as the response variable is the log-scaled population. Using the
#'  smoothing spline fit, the predicted population of ages 0 to 200 is obtained 
#'  and the predicted population is adjusted further using a ratio of the sum 
#'  of the population across all ages from the data and predicted population.
#'  The ratio is based on whether the ages are under the maximum age as the 
#'  total population across all ages differs for ages above and below the 
#'  maximum age. The maximum age population is adjusted further to drop off
#'  smoothly, based on the weights. The final population is then linearly
#'  extrapolated over years past the upper bound from the data. For ages above
#'  the maximum age from data, the population is calculated as a weighted 
#'  population of the maximum age that depends on the years past the upper 
#'  bound. Older ages would have lower weights, therefore lower population.
#' 
#' @return An interpolating function to get populations in 1y age increments
#' @examples
#' polymod_pop <- get_polymod_population()
#' 
#' polymod_pop
#' 
#' # But these ages and populations are binned every 5 years. So we can now
#' # provide a specified age and get the estimated population for that 1 year
#' # age group. First we create the new function like so
#' 
#' age_pop_function <- get_age_population_function(data=polymod_pop,
#'                                                  age_col = lower.age.limit,
#'                                                  pop_col= population)
#' # Then we pass it a year to get the estimated population for a particular age
#' age_pop_function(4)
#' 
#' # Or a vector of years, to get the estimated population for a particular age
#' # range
#' age_pop_function(1:4)
#' 
#' # Notice that we get a _pretty similar_ number of 0-4 if we sum it up, as 
#' # the first row of the table:
#' head(polymod_pop, 1)
#' sum(age_pop_function(age = 0:4))
#' 
#' # Usage in dplyr 
#' library(dplyr)
#' example_df <- slice_head(abs_education_state, n = 5)
#' example_df %>%
#' mutate(population_est = age_pop_function(age))
#' 
#' @export
get_age_population_function <- function(data = population, 
                                        age_col= lower.age.limit,
                                        pop_col= population) {
  
  
  # prepare population data for modelling
  pop_model <- data %>%
    dplyr::arrange(
      {{ age_col }}
    ) %>%
    dplyr::mutate(
      # model based on bin midpoint
      bin_width = bin_widths(  {{ age_col }} ),
      midpoint =  {{ age_col }} + bin_width / 2,
      # scaling down the population appropriately
      log_pop = log({{ pop_col }} / bin_width)
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
  
  total_pop <- dplyr::pull(pop_model, {{ pop_col }}) %>% sum()
  bounded_pop <- dplyr::pull(pop_model_bounded, {{ pop_col }}) %>% sum()
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
