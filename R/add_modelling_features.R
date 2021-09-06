# add features required for modelling to the dataset
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param contact_data PARAM_DESCRIPTION
#' @param ... PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname add_modelling_features
#' @export 
add_modelling_features <- function(contact_data, ...) {
  
  contact_data %>%
    add_population_age_to(...) %>%
    add_school_work_participation() %>%
    add_rotated_ages()
}
