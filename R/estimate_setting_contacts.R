#' Get predicted setting specific as well as combined contact matrices
#'
#' Given a named list of contact datasets (with names giving the setting, and
#' assumed to together make up the full set of contacts for individuals in the
#' survey), a representative population distribution for the survey, and a set
#' of age breaks at which to aggregate contacts, return a set of predicted
#' contact matrices for each setting, and for all combined.
#' 
#' @param contact_data_list list of data sets with information on the contacts of individuals at different settings
#' @param survey_population representative population distribution for the survey
#' @param prediction_population population for prediction. The default value set is survey_population
#' @param age_breaks vector depicting age values. For example, c(seq(0, 75, by = 5), Inf)
#' @param per_capita_household_size Optional (defaults to NULL). When set, it 
#'   adjusts the household contact matrix by some per capita household size. 
#'   To set it, provide a single number, the per capita household size. More
#'   information is provided below in Details. See 
#'   [get_per_capita_household_size()] function for a helper for Australian
#'    data with a workflow on how to get this number.
#' @return predicted setting specific contact matrices, and for all combined
#' @export
estimate_setting_contacts <- function(contact_data_list,
                                      survey_population,
                                      prediction_population = survey_population,
                                      age_breaks,
                                      per_capita_household_size = NULL) {
  
  setting_models <- fit_setting_contacts(
    contact_data_list = contact_data_list,
    population = survey_population
  )
  
  contact_model_pred <- predict_setting_contacts(
      population = prediction_population,
      contact_model = setting_models,
      age_breaks = age_breaks,
      per_capita_household_size = per_capita_household_size
    )
  
  contact_model_pred

}
