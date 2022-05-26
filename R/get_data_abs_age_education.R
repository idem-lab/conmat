#' @title Return  data on educated population for a given age and state or lga of Australia
#' @param state target Australian state name in abbreviated form, such as "QLD", "NSW", or "TAS"
#' @param lga target Australian local government area (LGA) name, such as "Fairfield (C)".  See
#'   [abs_lga_lookup()] for list of lga names
#' @param age a numeric or numeric vector denoting ages between 0 to 115
#' @return dataset with information on the number of educated people belonging to a particular age, its total population
#'  and the corresponding proportion.
#' @export
#' @examples
#' get_data_abs_age_education(state="VIC",age=1:10)
#' get_data_abs_age_education(lga="Albury (C)",age=10)
get_data_abs_age_education <- function(age, state=NULL, lga=NULL) {
  
  if (!is.null(state)) {
    check_state_name(state)
    
    data_subset <- data_abs_state_education %>%
      dplyr::filter(state %in% {{ state }})
    
  } else{
    check_lga_name(lga)
    data_subset <- data_abs_lga_education %>%
      dplyr::filter(lga %in% {{ lga }})
  }
 
  data_subset %>%
    dplyr::filter(age %in% {{ age }})
}