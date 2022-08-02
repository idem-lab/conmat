#' aggregate predicted contacts from complete 1y resolution
#'
#' aggregate predicted contacts from complete 1y resolution to a stated
#' resolution must pass in the population to do appropriate weighting of
#' 'from' age groups
#' @param predicted_contacts_1y contacts in 1 year breaks
#' @param population population
#' @param age_breaks Default: c(seq(0, 75, by = 5), Inf)
#' @return data frame
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
aggregate_predicted_contacts <- function(predicted_contacts_1y,
                                         population,
                                         age_breaks = c(
                                           seq(0, 75, by = 5),
                                           Inf
                                         )) {

  # get function for 1y age populations in this country
  age_population_function <- get_age_population_function(population)

  # aggregate contacts within age breaks
  predicted_contacts_1y %>%
    dplyr::mutate(
      age_group_to = cut(
        pmax(0.1, age_to),
        age_breaks,
        right = FALSE
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
        age_breaks,
        right = FALSE
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
