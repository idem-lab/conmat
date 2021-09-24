#' Fit a contact model to a survey poulation
#' @param contact_data_list contact_data_list
#' @param population survey_population
#' @return list of fitted gam models
#' @author Nicholas Tierney
#' @export
#' @examples 
#' # don't run as it takes too long to fit
#' \dontrun{
#' contact_model <- fit_setting_contacts(
#'   contact_data_list = get_polymod_setting_data(), 
#'   population = get_polymod_population()
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
