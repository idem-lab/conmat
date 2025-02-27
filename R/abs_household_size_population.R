#' @title Get population associated with each household size in an LGA or a state
#' @param state target Australian state name in abbreviated form, such as "QLD", "NSW", or "TAS"
#' @param lga target Australian local government area (LGA) name, such as "Fairfield (C)".  See
#'   [abs_lga_lookup()] for list of lga names
#' @return returns a data frame with household size and the population associated with it in each LGA or state.
#' @export
#' @examples
#' get_abs_household_size_population(state = "NSW")
get_abs_household_size_population <- function(state = NULL, lga = NULL) {
  level <- dplyr::case_when(
    is.null(state) & is.null(lga) ~ "national",
    !is.null(state) & is.null(lga) ~ "state",
    is.null(state) & !is.null(lga) ~ "lga",
    TRUE ~ "erroneous"
  )

  # get state mean household sizes
  household_data <- abs_household_lga %>%
    dplyr::filter(
      year == max(year),
      n_persons_usually_resident != "total"
    ) %>%
    dplyr::mutate(
      # household size as a number, assuming all people in households 8+ are
      # exactly 8
      size = readr::parse_number(n_persons_usually_resident),
      # number of *people* in a household of that size
      n_people = n_households * size,
    ) %>%
    dplyr::select(-c(n_persons_usually_resident, n_households)) %>%
    dplyr::rename(household_size = size)

  household_data <- switch(
    level,
    national = household_data,
    state = household_data %>%
      dplyr::filter(state == !!state),
    lga = household_data %>%
      dplyr::filter(lga == !!lga)
  )
  return(household_data)
}
