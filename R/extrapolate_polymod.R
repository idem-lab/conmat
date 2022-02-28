#' fit all-of-polymod model and extrapolate to a given population an age breaks
#'
#' @param population PARAM_DESCRIPTION
#' @param age_breaks PARAM_DESCRIPTION, Default: c(seq(0, 75, by = 5), Inf)
#' @param per_capita_household_size PARAM_DESCRIPTION, Default : NULL
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
extrapolate_polymod <- function(population,
                                age_breaks = c(seq(0, 75, by = 5), Inf),
                                per_capita_household_size = NULL) {
  estimate_setting_contacts(
    contact_data_list = get_polymod_setting_data(),
    survey_population = get_polymod_population(),
    prediction_population = population,
    age_breaks = age_breaks,
    per_capita_household_size = per_capita_household_size
  )
}
