
#' Predict setting contacts
#'
#' Predict contact rate for each setting. Note that this function is
#' parallelisable with `future`, and will be impacted by any `future` plans
#' provided.
#'
#' @param population population
#' @param contact_model contact_model
#' @param age_breaks age_breaks
#' @param per_capita_household_size Optional (defaults to NULL). When set, it
#'   adjusts the household contact matrix by some per capita household size.
#'   To set it, provide a single number, the per capita household size. More
#'   information is provided below in Details. See
#'   [get_abs_per_capita_household_size()] function for a helper for Australian
#'    data with a workflow on how to get this number.
#' @param model_per_capita_household_size modelled per capita household size.
#'     Default values for this are from
#'     [get_polymod_per_capita_household_size()], which ends up being 3.248971
#'
#' @details We use Per-capita household size instead of mean household size.
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
#' @return List of setting matrices
#' @author Nicholas Tierney
#' @export
#' @examples
#' # don't run as it takes too long to fit
#' \dontrun{
#' fairfield <- abs_age_lga("Fairfield (C)")
#' fairfield
#'
#' age_break_0_85_plus <- c(seq(0, 85, by = 5), Inf)
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
#'   population = fairfield,
#'   contact_model = setting_models,
#'   age_breaks = age_break_0_85_plus
#' )
#'
#' fairfield_hh_size <- get_abs_per_capita_household_size(lga = "Fairfield (C)")
#' fairfield_hh_size
#'
#' synthetic_settings_5y_fairfield_hh <- predict_setting_contacts(
#'   population = fairfield,
#'   contact_model = setting_models,
#'   age_breaks = age_break_0_85_plus,
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
  setting_matrices$all <- new_age_matrix(
    matrix = setting_matrices$all,
    age_breaks = age_breaks
  )

  # if we haven't set anything for the per capita household size, return this
  # adjusted matrix
  # otherwise we want to adjust the household contact matrix (which also
  # updates the "all" setting matrix).
  if (!is.null(per_capita_household_size)) {
    setting_matrices <- adjust_household_contact_matrix(
      setting_matrices = setting_matrices,
      # how do we choose this household size?
      per_capita_household_size = per_capita_household_size,
      # extra arguments to adjust_household_contact_matrix
      model_per_capita_household_size = model_per_capita_household_size
    )
  }

  setting_matrices <- new_setting_prediction_matrix(setting_matrices,
    age_breaks = age_breaks
  )

  return(setting_matrices)
}
