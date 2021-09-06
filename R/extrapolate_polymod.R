# fit all-of-polymod model and extrapolate to a given population an age breaks
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param population PARAM_DESCRIPTION
#' @param age_breaks PARAM_DESCRIPTION, Default: c(seq(0, 75, by = 5), Inf)
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname extrapolate_polymod
#' @export 
extrapolate_polymod <- function(
  population,
  age_breaks = c(seq(0, 75, by = 5), Inf)
) {
  estimate_setting_contacts(
    contact_data_list = get_polymod_setting_data(),
    survey_population = get_polymod_population(),
    prediction_population = population, 
    age_breaks = age_breaks
  )
}
