#' fit all-of-polymod model and extrapolate to a given population an age breaks
#'
#' @param population data set with information on the population of the desired location
#' @param age_breaks vector depicting age values. Default value is c(seq(0, 75, by = 5), Inf)
#' @param per_capita_household_size Optional (defaults to NULL). When set, it 
#'   adjusts the household contact matrix by some per capita household size. 
#'   To set it, provide a single number, the per capita household size. More
#'   information is provided below in Details. See 
#'   [get_per_capita_household_size()] function for a helper for Australian
#'    data with a workflow on how to get this number.
#' @return Returns setting-specific and combined contact matrices for the desired ages
#' @examples
#' \dontrun{
#' polymod_population <- get_polymod_population()
#' synthetic_settings_5y_polymod <- extrapolate_polymod(population = polymod_population)
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
