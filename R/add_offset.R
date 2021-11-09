#' @title Adds offset
#' @return contact data with two extra columns: 
#'   `log_contactable_population_school` and `log_contactable_population`
#' @param contact_data contact_data
#' @author Nick Golding
#' @export
add_offset <- function(contact_data) {

  # define the offset variable for the model: the log population for most
  # settings, one that captures cohorting of students for schools. Define both,
  # and set the choice of which one in the model formula
  contact_data %>%
    dplyr::mutate(
      log_contactable_population_school = log(school_weighted_pop_fraction),
      log_contactable_population = log(pop_age_to)
    )

}
