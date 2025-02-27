#' @title Get household size distribution based on  LGA name
#' @param lga target Australian local government area (LGA) name, such as "Fairfield (C)".  See
#'   [abs_lga_lookup()] for list of lga names
#' @return returns a numeric value depicting the per capita household size of the specified LGA
#' @export
#' @examples
#' get_abs_per_capita_household_size_lga(lga = "Fairfield (C)")
#'
get_abs_per_capita_household_size_lga <- function(lga = NULL) {
  check_lga_name(lga, multiple_lga = FALSE)

  # given ABS data on household sizes for a *single location*, get average
  # household sizes *per person* from ABS - assuming a max of 8 people per
  # households. Note - I tried computing the mean size of the households larger
  # than 7, by comparing with LGA populations, but they were improbably
  # enormous, probably because some of the population lives in facilities, not
  # households.

  lga <- rlang::enquo(lga)

  household_data <- get_abs_household_size_population(lga = lga)
  # set up aggregation
  household_data <- household_data %>%
    dplyr::filter(lga == !!lga) %>%
    dplyr::group_by(lga)

  # aggregate and average household sizes
  household_data %>%
    per_capita_household_size()
}
