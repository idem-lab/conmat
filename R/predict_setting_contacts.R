#' @title Predict contact rate between age groups across all settings
#' 
#' @description Predicts the expected contact rate across all settings ("home",
#'   "school", "work", and "other") over specified age breaks, 
#'  given some model of contact rate and population age structure. Optionally 
#'  performs an adjustment for per capita household size. See "details" for more
#'  information.
#'    
#' @details The population data is used to determine age range to predict 
#'   contact rates, and removes ages with zero population, so we do not 
#'   make predictions for ages with zero populations. Contact rates are 
#'   predicted yearly between the age groups, using [predict_contacts_1y()], 
#'   then aggregates these predicted contacts using 
#'   [aggregate_predicted_contacts()], which aggregates the predictions back to 
#'   the same resolution as the data, appropriately weighting the contact rate 
#'   by the population. Predictions are converted to matrix format using
#'   [predictions_to_matrix()] to produce contact matrices for all age groups
#'   combinations across different settings or location of contact.
#'   
#'   We use Per-capita household size instead of mean household size.
#'     Per-capita household size is different to mean household size, as the 
#'     household size averaged over **people** in the population, not over 
#'     households, so larger households get upweighted. It is calculated by 
#'     taking a distribution of the number of households of each size in a 
#'     population, multiplying the size by the household by the household count 
#'     to get the number of people with that size of household, and computing 
#'     the population-weighted average of household sizes. We use per-capita 
#'     household size as it is a more accurate reflection of the average 
#'     number of household members a person in the population can have contact 
#'     with.
#' 
#' @param population a dataframe of age population information, with columns 
#'    indicating some lower age limit, and population, (e.g., [get_polymod_population()])
#' @param contact_model A list of GAM models for each setting. See example
#'   output from `fit_setting_contact` below
#' @param age_breaks A vector of age breaks.
#' @param per_capita_household_size Optional (defaults to NULL). When set, it 
#'   adjusts the household contact matrix by some per capita household size. 
#'   To set it, provide a single number, the per capita household size. More
#'   information is provided below in Details. See 
#'   [get_per_capita_household_size()] function for a helper for Australian
#'    data with a workflow on how to get this number.
#' @param model_per_capita_household_size modelled per capita household size.
#'     Default values for this are from 
#'     [get_polymod_per_capita_household_size()], which ends up being 3.248971
#'
#'     
#' @return List of contact rate of matrices for each setting: ("home", "work",
#'   "school", "other").
#'   
#' @author Nicholas Tierney
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
#' @export
predict_setting_contacts <- function(population, 
                                     contact_model, 
                                     age_breaks,
                                     per_capita_household_size = NULL,
                                     model_per_capita_household_size =
                                       get_polymod_per_capita_household_size()) {

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
      per_capita_household_size = per_capita_household_size,
      # extra arguments to adjust_household_contact_matrix
      model_per_capita_household_size = model_per_capita_household_size
      )
    return(
      setting_matrices
    )
    
  }

}
