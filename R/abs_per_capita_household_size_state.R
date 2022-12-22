#' @title Get household size distribution based on state name
#' @param state target Australian state name in abbreviated form, such as "QLD", "NSW", or "TAS"
#' @return returns a numeric value depicting the per capita household size of the specified state
#' @export
#' @examples
#' abs_per_capita_household_size_state(state = "NSW")
abs_per_capita_household_size_state <- function(state = NULL) {
  check_state_name(state, multiple_state = FALSE)

  # given ABS data on household sizes for a *single location*, get average
  # household sizes *per person* from ABS - assuming a max of 8 people per
  # households. Note - I tried computing the mean size of the households larger
  # than 7, by comparing with LGA populations, but they were improbably
  # enormous, probably because some of the population lives in facilities, not
  # households.

  state <- rlang::enquo(state)
  # get state mean household sizes
  household_data <- abs_household_size_population(state = state)



  # set up aggregation
  household_data <- household_data %>%
    dplyr::filter(state == !!state) %>%
    dplyr::group_by(state)

  # aggregate and average household sizes
  household_data %>%
    per_capita_household_size()
}
