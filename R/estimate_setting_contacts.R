#' Get predicted contact matrices for each setting and combined
#'
#' Given a named list of contact datasets (with names giving the setting, and
#' assumed to together make up the full set of contacts for individuals in the
#' survey), a representative population distribution for the survey, and a set
#' of age breaks at which to aggregate contacts, return a set of predicted
#' contact matrices for each setting, and for all combined.
#' @param contact_data_list PARAM_DESCRIPTION
#' @param survey_population PARAM_DESCRIPTION
#' @param prediction_population PARAM_DESCRIPTION, Default: survey_population
#' @param age_breaks PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
estimate_setting_contacts <- function(contact_data_list,
                                      survey_population,
                                      prediction_population = survey_population,
                                      age_breaks) {
  setting_models <- lapply(
    X = contact_data_list,
    FUN = fit_single_contact_model,
    population = survey_population
  )

  setting_predictions <- lapply(
    X = setting_models,
    FUN = predict_contacts,
    population = prediction_population,
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
