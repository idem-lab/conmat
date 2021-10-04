#' Predict setting contacts
#' @param population population
#' @param contact_model contact_model
#' @param age_breaks age_breaks
#' @param household_size_distribution household_size_distribution
#' @return list of matrices
#' @author Nicholas Tierney
#' @export
#' @examples 
#' # don't run as it takes too long to fit
#' \dontrun{
#' contact_model <- fit_setting_contacts(
#'   contact_data_list = get_polymod_setting_data(), 
#'   survey_population = get_polymod_population()
#' )
#' 
#' contact_model
#' 
#' contact_model_pred <- predict_setting_contacts(
#'   population = get_polymod_population(), 
#'   contact_model = contact_model, 
#'   age_breaks = c(seq(0, 75, by = 5), Inf)
#' )
#' 
#' # Adjust the household size distribution
#' synthetic_settings_5y_fairfield <- predict_setting_contacts(
#'   population = fairfield_age_pop,
#'   contact_model = setting_models,
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   household_size_distribution = fairfield_household_sizes
#' )
#' }
predict_setting_contacts <- function(population, 
                                     contact_model, 
                                     age_breaks,
                                     household_size_distribution = NULL) {

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
  
  setting_matrices

}
