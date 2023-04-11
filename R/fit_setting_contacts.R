#' Fit a contact model to a survey population
#'
#' fits a gam model for each setting on the survey population data & the
#'   setting wise contact data. The underlying method is described in more
#'   detail in [fit_single_contact_model()]. The models can be fit in parallel,
#'   see the examples. Note that this function is parallelisable with `future`,
#'   and will be impacted by any `future` plans provided.
#'
#' @param contact_data_list A list of dataframes, each containing information
#'   on the setting (home, work, school, other), age_from, age_to,
#'   the number of contacts, and the number of participants. Example data
#'   can be retrieved with [get_polymod_setting_data()].
#' @param population `conmat_population` object or dataset with columns
#'   `lower.age.limit` and `population`. Example data can be retrieved with
#'   [get_polymod_population()].
#' @param symmetrical whether to enforce symmetrical terms in the model.
#'   Defaults to TRUE. See `details` of `fit_single_contact_model` for more
#'   information.
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
#' @return list of fitted gam models - one for each setting provided
#' @author Nicholas Tierney
#' @export
#' @examples
#' # These aren't being  run as they take too long to fit
#' \dontrun{
#' contact_model <- fit_setting_contacts(
#'   contact_data_list = get_polymod_setting_data(),
#'   population = get_polymod_population()
#' )
#'
#' # can fit the model in parallel
#' library(future)
#' plan(multisession, workers = 4)
#'
#' polymod_setting_data <- get_polymod_setting_data()
#' polymod_population <- get_polymod_population()
#'
#' contact_model <- fit_setting_contacts(
#'   contact_data_list = polymod_setting_data,
#'   population = polymod_population
#' )
#'
#' # you can specify your own population data for school and work demographics
#' contact_model_diff_data <- fit_setting_contacts(
#'   contact_data_list = polymod_setting_data,
#'   population = polymod_population,
#'   school_demographics = conmat_original_school_demographics,
#'   work_demographics = conmat_original_work_demographics
#' )
#' }
fit_setting_contacts <- function(contact_data_list,
                                 population,
                                 symmetrical = TRUE,
                                 school_demographics = NULL,
                                 work_demographics = NULL) {
  check_if_list(contact_data_list)

  fitted_setting_contacts <- furrr::future_map(
    .x = contact_data_list,
    .f = fit_single_contact_model,
    population = population,
    symmetrical = symmetrical,
    school_demographics = NULL,
    work_demographics = NULL,
    .options = furrr::furrr_options(seed = TRUE)
  )

  new_setting_contact_model(fitted_setting_contacts)
}
