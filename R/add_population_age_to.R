# add the population distribution for contact ages. If 'polymod' then use the
# participant-weighted average of polymod country/year distributions
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param contact_data PARAM_DESCRIPTION
#' @param population PARAM_DESCRIPTION, Default: get_polymod_population()
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[dplyr]{mutate}}
#' @rdname add_population_age_to
#' @export 
#' @importFrom dplyr mutate
add_population_age_to <- function(contact_data, population = get_polymod_population()) {
  
  # get function to interpolate population age distributions to 1y bins 
  age_population_function <- get_age_population_function(population)
  
  # add the population in each 'to' age for the survey context
  contact_data %>%
    dplyr::mutate(
      pop_age_to = age_population_function(age_to)
    )
  
}