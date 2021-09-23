#' Predict setting contacts
#' @param population population
#' @param contact_model contact_model
#' @param age_breaks age_breaks
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
#' }
predict_setting_contacts <- function(population, contact_model, age_breaks) {

  setting_predictions <- lapply(
    X = contact_model,
    FUN = predict_contacts,
    population = population,
    age_breaks = age_breaks
  )
  
  setting_matrices <- lapply(
    X = setting_predictions,
    FUN = predictions_to_matrix
  )
  
  combination <- Reduce("+", setting_matrices)
  setting_matrices$all <- combination
  
  setting_matrices

}
