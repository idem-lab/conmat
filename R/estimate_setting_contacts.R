#' @title Get predicted setting specific as well as combined contact matrices
#'
#' @description Given a named list of contact datasets (with names giving
#'   the setting, and assumed to together make up the full set of contacts for
#'   individuals in the survey), a representative population distribution for
#'   the survey, and a set of age breaks at which to aggregate contacts, return
#'   a set of predicted contact matrices for each setting, and for all combined.
#'   Note that this function is parallelisable with `future`, and will be
#'   impacted by any `future` plans provided.
#'
#' @param contact_data_list list of data sets with information on the contacts
#'   of individuals at different settings
#'
#' @param survey_population representative population distribution for the
#'   survey
#'
#' @param prediction_population population for prediction. The default value
#'   set is survey_population
#'
#' @param age_breaks vector depicting age values. For example,
#'   `c(seq(0, 75, by = 5), Inf)`
#'
#' @param per_capita_household_size Optional (defaults to NULL). When set, it
#'   adjusts the household contact matrix by some per capita household size.
#'   To set it, provide a single number, the per capita household size. More
#'   information is provided below in Details. See
#'   [get_abs_per_capita_household_size()] function for a helper for Australian
#'    data with a workflow on how to get this number.
#'
#' @param symmetrical whether to enforce symmetrical terms in the model.
#'   Defaults to TRUE. See `details` of `fit_single_contact_model` for more
#'   information.
#'
#' @param school_demographics (optional) defaults to census average proportion
#'    at school. You can provide a dataset with columns, "age" (numeric), and
#'    "school_fraction" (0-1), if you would like to specify these
#'    details. See `abs_avg_school` for the default values. If you would like to
#'    use the original school demographics used in conmat, these are provided in
#'    the dataset, `conmat_original_school_demographics`.
#' @param work_demographics (optional) defaults to census average proportion
#'    employed. You can provide a dataset with columns, "age" (numeric), and
#'    "work_fraction", if you would like to specify these details. See
#'    `abs_avg_work` for the default values. If you would like to
#'    use the original work demographics used in conmat, these are provided in
#'    the dataset, `conmat_original_work_demographics`.
#'
#' @return predicted setting specific contact matrices, and for all combined
#'
#' @examples
#' \dontrun{
#' # takes a long time to run
#' settings_estimated_contacts <- estimate_setting_contacts(
#'   contact_data_list = get_polymod_setting_data(),
#'   survey_population = get_polymod_population(),
#'   prediction_population = get_polymod_population(),
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   per_capita_household_size = NULL
#' )
#'
#' # or predict to fairfield
#' fairfield_hh <- get_abs_per_capita_household_size(lga = "Fairfield (C)")
#' contact_model_pred_est <- estimate_setting_contacts(
#'   contact_data_list = get_polymod_setting_data(),
#'   survey_population = get_polymod_population(),
#'   prediction_population = abs_age_lga("Fairfield (C)"),
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   per_capita_household_size = fairfield_hh
#' )
#'
#' # or use different populations in school or work demographics
#' fairfield_hh <- get_abs_per_capita_household_size(lga = "Fairfield (C)")
#' contact_model_pred_est <- estimate_setting_contacts(
#'   contact_data_list = get_polymod_setting_data(),
#'   survey_population = get_polymod_population(),
#'   prediction_population = abs_age_lga("Fairfield (C)"),
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   per_capita_household_size = fairfield_hh,
#'   school_demographics = conmat_original_school_demographics,
#'   work_demographics = conmat_original_work_demographics
#' )
#'
#' # or use non-symmetric model terms
#' contact_model_pred_est <- estimate_setting_contacts(
#'   contact_data_list = get_polymod_setting_data(),
#'   survey_population = get_polymod_population(),
#'   prediction_population = abs_age_lga("Fairfield (C)"),
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   per_capita_household_size = fairfield_hh,
#'   symmetrical = FALSE
#' )
#' }
#' @export
estimate_setting_contacts <- function(contact_data_list,
                                      survey_population,
                                      prediction_population = survey_population,
                                      age_breaks,
                                      per_capita_household_size = NULL,
                                      symmetrical = TRUE,
                                      school_demographics = NULL,
                                      work_demographics = NULL) {
  setting_models <- fit_setting_contacts(
    contact_data_list = contact_data_list,
    population = survey_population,
    symmetrical = symmetrical,
    school_demographics = school_demographics,
    work_demographics = work_demographics
  )

  contact_model_pred <- predict_setting_contacts(
    population = prediction_population,
    contact_model = setting_models,
    age_breaks = age_breaks,
    per_capita_household_size = per_capita_household_size
  )

  contact_model_pred
}
