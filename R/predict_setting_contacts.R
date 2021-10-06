#' Predict setting contacts
#' @param population population
#' @param contact_model contact_model
#' @param age_breaks age_breaks
#' @param per_capita_household_size Optional (defaults to NULL). When set, it 
#'   adjusts the household contact matrix by some per capital household size. 
#'   To set it, provide a single number, which is the per capita household size. 
#'   See `get_per_capita_household_size()` function for a helper for Australian
#'    data with a workflow on how to ge this number.
#' @param ... extra arguments to pass to the `per_capita_household_size` 
#'     adjustment - see `adjust_household_contact_matrix` for details. 
#'     Default values for this are `household_contact_rate = 1` and 
#'     `model_mean_other_householders = 2.248971`.
#' @return List of setting matrices
#' @author Nicholas Tierney
#' @export
#' @examples 
#' # don't run as it takes too long to fit
#' \dontrun{
#' fairfield_age_pop <- abs_age_lga("Fairfield (C)")
#' fairfield_age_pop
#' 
#' polymod_contact_data <- get_polymod_setting_data()
#' polymod_survey_data <- get_polymod_population()
#' 
#' setting_models <- fit_setting_contacts(
#'   contact_data_list = polymod_contact_data,
#'   population = polymod_survey_data
#' )
#' 
#' synthetic_settings_5y_fairfield <- predict_setting_contacts(
#'   population = fairfield_age_pop,
#'   contact_model = setting_models,
#'   age_breaks = c(seq(0, 85, by = 5), Inf)
#' )
#' 
#' fairfield_hh_size <- get_per_capita_household_size(lga = "Fairfield (C)")
#' fairfield_hh_size
#' 
#' synthetic_settings_5y_fairfield_hh <- predict_setting_contacts(
#'   population = fairfield_age_pop,
#'   contact_model = setting_models,
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   per_capita_household_size = fairfield_hh_size
#' )
#' }
predict_setting_contacts <- function(population, 
                                     contact_model, 
                                     age_breaks,
                                     per_capita_household_size = NULL,
                                     ...) {

  setting_predictions <- furrr::future_map(
    .x = contact_model,
    .f = predict_contacts,
    population = population,
    age_breaks = age_breaks,
    .options = furrr::furrr_options(seed = TRUE)
  )
  
  setting_matrices <- furrr::future_map(
    .x = setting_predictions,
    .f = predictions_to_matrix,
    .options = furrr::furrr_options(seed = TRUE)
  )
  
  combination <- Reduce("+", setting_matrices)
  setting_matrices$all <- combination
  
  # if we haven't set anything for the per capita household size, return this
  # adjusted matrix
  if (is.null(per_capita_household_size)) {
    return(setting_matrices)
  
  # otherwise we want to adjust the household contact matrix (which also 
    # updates the "all" setting matrix).
  } else if (!is.null(per_capita_household_size)){
    setting_matrices <- adjust_household_contact_matrix(
      setting_matrices = setting_matrices,
      # how do we choose this household size?
      household_size = per_capita_household_size,
      population = population,
      # extra arguments to adjust_household_contact_matrix
      ...
      )
    return(
      setting_matrices
    )
    
  }

}
