#' @title Return employed population data for a given age and state or lga of Australia
#' @param state target Australian state name in abbreviated form, such as "QLD", "NSW", or "TAS"
#' @param lga target Australian local government area (LGA) name, such as "Fairfield (C)".  See
#'   [abs_lga_lookup()] for list of lga names
#' @param age a numeric denoting age
#' @return data set with information on the number of people employed belonging to the given age, its total population
#'  and the corresponding proportion.
#' @export
#' @examples
#' get_data_abs_age_work(state="NSW",age=9)
#' get_data_abs_age_work(lga="Albury (C)",age=10)
get_data_abs_age_work <- function(age, state=NULL, lga=NULL) {
  
  if (!is.null(state)) {
    check_state_name(state)
    
    data <- data_abs_state_work %>%
      dplyr::filter(state=={{ state }})
    
  } else{
    check_lga_name(lga)
    data <- data_abs_lga_work %>%
      dplyr::filter(lga=={{ lga }})
  }
  # check LGA name
  data %>%
    filter(age == {{ age }})
}