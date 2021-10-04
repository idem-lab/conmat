#' @title
#' @param household_data
#' @return
#' @author Nick Golding
#' @export
get_mean_household_size <- function(state = NULL, lga = NULL) {
  
  level <- dplyr::case_when(
    is.null(state) & is.null(lga) ~ "national",
    !is.null(state) & is.null(lga) ~ "state",
    is.null(state) & !is.null(lga) ~ "lga",
    TRUE ~ "erroneous"
  )
  
  if (level == "erroneous") {
    stop ("only one of state and lga may be specified")
  }
  
  if (length(state) > 1 | length(lga) > 1) {
    stop ("only one state or LGA at a time, please")
  }
  
  # given ABS data on household sizes for a *single location*, get average
  # household sizes *per person* from ABS - assuming a max of 8 people per
  # households. Note - I tried computing the mean size of the households larger
  # than 7, by comparing with LGA populations, but they were improbably
  # enormous, probably because some of the population lives in facilities, not
  # households.
  
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
    )
  
  state <- rlang::enquo(state)
  lga <- rlang::enquo(lga)
  
  # set up aggregation
  household_data <- switch(
    
    level,
    
    national = household_data,
    
    state = household_data %>%
      dplyr::filter(state == !!state) %>%
      dplyr::group_by(state),
    
    lga = household_data %>%
      dplyr::filter(lga == !!lga) %>%
      dplyr::group_by(lga)
    
  )
  
  if (nrow(household_data) == 0) {
    stop(
        glue::glue("{level} '{paste(get(level))[2]}' not found")
      )
  }
  
  # aggregate and average household sizes
  household_data %>%
    dplyr::group_by(
      size,
      .add = TRUE
    ) %>%
    dplyr::summarise(
      n_people = sum(n_people),
      .groups = "drop"
    ) %>%
    dplyr::mutate(
      # as a fraction of the population
      fraction = n_people / sum(n_people)
    ) %>%
    dplyr::summarise(
      mean_household_size = sum(size * fraction),
      .groups = "drop"
    ) %>%
    dplyr::pull(
      mean_household_size
    )
  
}
