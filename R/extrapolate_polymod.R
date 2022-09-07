#' Fit all-of-polymod model and extrapolate to a given population an age breaks
#' 
#' Uses [estimate_setting_contacts()] to fit a contact model on the data from
#'   polymod and later extrapolate on to a desired population.
#'
#' @param population data set with information on the population of the desired
#'   location - containing `lower.age.limit` and `population` columns. See
#'   `get_polymod_population()` for an example of this data.
#' @param age_breaks vector depicting age values. Default value is 
#'   `c(seq(0, 75, by = 5), Inf)`
#' @param per_capita_household_size Optional (defaults to NULL). When set, it 
#'   adjusts the household contact matrix by some per capita household size. 
#'   To set it, provide a single number, the per capita household size. More
#'   information is provided below in Details. See 
#'   [get_per_capita_household_size()] function for a helper for Australian
#'    data with a workflow on how to get this number.
#' @return Returns setting-specific and combined contact matrices for the 
#'   desired ages.
#' @examples
#' \dontrun{
#' polymod_population <- get_polymod_population()
#' synthetic_settings_5y_polymod <- extrapolate_polymod(
#'   population = polymod_population
#' )
#' synthetic_settings_5y_polymod
#' synthetic_settings_5y_fairfield <- extrapolate_polymod(
#'   population = abs_age_lga("Fairfield (C)")
#' )
#' synthetic_settings_5y_fairfield
#' )
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
