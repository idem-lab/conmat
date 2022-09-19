#' Fit a contact model to a survey poulation
#' 
#' fits a gam model for each setting on the survey population data & the
#'   setting wise contact data. The underlying method is described in more 
#'   detail in [fit_single_contact_model()]. The models can be fit in parallel,
#'   see the examples.
#' 
#' @param contact_data_list A list of dataframes, each containing informatio
#'   on the setting (home, work, school, other), age_from, age_to,
#'   the number of contacts, and the number of participants. Example data
#'   can be retrieved with [get_polymod_setting_data()].
#' @param population survey population data, containing columns 
#'   `lower.age.limit` and `population`. Example data can be retrieved with
#'   [get_polymod_population()].
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
#' }
fit_setting_contacts <- function(contact_data_list, population) {

  furrr::future_map(
    .x = contact_data_list,
    .f = fit_single_contact_model,
    population = population,
    .options = furrr::furrr_options(seed = TRUE)
  )

}
