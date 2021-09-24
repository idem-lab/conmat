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
#' @export
estimate_setting_contacts <- function(contact_data_list,
                                      survey_population,
                                      prediction_population = survey_population,
                                      age_breaks) {
  
  setting_models <- fit_setting_contacts(
    contact_data_list = contact_data_list,
    population = survey_population
  )
  
  contact_model_pred <- predict_setting_contacts(
      population = prediction_population,
      contact_model = setting_models,
      age_breaks = age_breaks
    )
  
  contact_model_pred

}
