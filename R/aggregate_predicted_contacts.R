#' @title Aggregate predicted contacts to specified age breaks
#'
#' @description Aggregates contacts rate from, say, a 1 year level into
#'   provided age  breaks, weighting the contact rate by the specified age
#'   population. For example, if you specify breaks as c(0, 5, 10, 15, Inf),
#'   it will return age groups as 0-5, 5-10, 10-15, and 15+ (Inf). Used
#'   internally within [predict_contacts()], although can be used by users.
#'
#' @param predicted_contacts_1y contacts in 1 year breaks (could technically
#'   by in other year breaks). Data must contain columns, `age_from`, `age_to`,
#'   `contacts`, and `se_contacts`, which is the same output as
#'   [predict_contacts_1y()] - see examples below.
#' @param population a `conmat_population` object, which has the `age` and
#'   `population` columns specified, or a dataframe with columns
#'   `lower.age.limit`, and `population`. See examples below.
#' @param age_breaks vector of ages. Default: c(seq(0, 75, by = 5), Inf)
#' @return data frame with columns, `age_group_from`, `age_group_to`, and
#'  `contacts`, which is the aggregated model.
#' @examples
#' fairfield <- abs_age_lga("Fairfield (C)")
#'
#' fairfield
#'
#' # We can predict the contact rate for Fairfield from the existing contact
#' # data, say, between the age groups of 0-15 in 5 year bins for school:
#'
#' fairfield_contacts_1 <- predict_contacts_1y(
#'   model = polymod_setting_models$home,
#'   population = fairfield,
#'   age_min = 0,
#'   age_max = 15
#' )
#'
#' fairfield_contacts_1
#'
#' aggregated_fairfield <- aggregate_predicted_contacts(
#'   predicted_contacts_1y = fairfield_contacts_1,
#'   population = fairfield,
#'   age_breaks = c(0, 5, 10, 15, Inf)
#' )
#'
#' aggregated_fairfield
#' @export
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
    # population distribution (to get contacts for the population-average 
    # member of that age group)
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
