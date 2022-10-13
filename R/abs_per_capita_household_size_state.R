#' @title Get household size distribution based on state name
#' @param state target Australian state name in abbreviated form, such as "QLD", "NSW", or "TAS"
#' @return returns a data frame with household size distributions of a specific state.
#' Data frame contains variables depicting the lga wise household size (number of people in a household) and the associated population.  
#' @export
#' @examples 
#'abs_per_capita_household_size_state(state = c("NSW","TAS"))
abs_per_capita_household_size_state <- function(state = NULL) {
  
  
  check_state_name(state,multiple_state = TRUE)
  
  # given ABS data on household sizes for a *single location*, get average
  # household sizes *per person* from ABS - assuming a max of 8 people per
  # households. Note - I tried computing the mean size of the households larger
  # than 7, by comparing with LGA populations, but they were improbably
  # enormous, probably because some of the population lives in facilities, not
  # households.
  
  # get state mean household sizes
  household_data <- abs_household_lga %>%
    dplyr::filter(year == max(year),
                  n_persons_usually_resident != "total") %>%
    dplyr::mutate(
      # household size as a number, assuming all people in households 8+ are
      # exactly 8
      size = readr::parse_number(n_persons_usually_resident),
      # number of *people* in a household of that size
      n_people = n_households * size,
    ) %>%
    dplyr::select(-c(n_persons_usually_resident, n_households)) %>%
    dplyr::rename(household_size = size)
  
  state <- rlang::enquo(state)
  
  # set up aggregation
  household_data <-  household_data %>%
    dplyr::filter(state %in% !!state) %>%
    dplyr::group_by(state)
  
  household_data
}

