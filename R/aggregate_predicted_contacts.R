# aggregate predicted contacts from complete 1y resolution to a stated resolution
# must pass in the population to do approppriate weighting of 'from' age groups
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param predicted_contacts_1y PARAM_DESCRIPTION
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
#' @seealso 
#'  \code{\link[dplyr]{mutate}},\code{\link[dplyr]{filter}},\code{\link[dplyr]{group_by}},\code{\link[dplyr]{summarise}}
#'  \code{\link[stats]{weighted.mean}}
#' @rdname aggregate_predicted_contacts
#' @export 
#' @importFrom dplyr mutate filter group_by summarise
#' @importFrom stats weighted.mean
aggregate_predicted_contacts <- function(
  predicted_contacts_1y,
  population,
  age_breaks = c(
    seq(0, 75, by = 5),
    Inf
  )
) {
  
  # get function for 1y age populations in this country
  age_population_function <- get_age_population_function(population)
  
  # aggregate contacts within age breaks
  predicted_contacts_1y %>%
    dplyr::mutate(
      age_group_to = cut(
        pmax(0.1, age_to),
        age_breaks
      )
    ) %>%
    dplyr::filter(
      !is.na(age_group_to)
    ) %>%
    # sum the number of contacts to the 'to' age groups, for each integer
    # participant age
    dplyr::group_by(
      age_from,
      age_group_to
    ) %>%
    dplyr::summarise(
      contacts = sum(contacts),
      .groups = "drop"
    ) %>%
    # *average* the total contacts within the 'from' contacts, weighted by the
    # population distribution (to get contacts for the population-average ember of
    # that age group)
    dplyr::mutate(
      pop_age_from = age_population_function(age_from),
      age_group_from = cut(
        pmax(0.1, age_from),
        age_breaks
      )
    ) %>%
    dplyr::filter(
      !is.na(age_group_from)
    ) %>%
    dplyr::group_by(
      age_group_from,
      age_group_to
    ) %>%
    dplyr::summarise(
      contacts = stats::weighted.mean(contacts, pop_age_from),
      .groups = "drop"
    )
}
