#' @title Get household size distribution based on state or LGA name
#' @param state target Australian state name in abbreviated form, such as "QLD", "NSW", or "TAS"
#' @param lga target Australian local government area (LGA) name, such as "Fairfield (C)".  See
#'   [abs_lga_lookup()] for list of lga names
#' @return returns a data frame with household size distributions of a specific state or LGA
#' @export
#' @examples
#' get_abs_household_size_distribution(lga = "Fairfield (C)")
#' get_abs_household_size_distribution(state = "NSW")
#' \dontrun{
#' # cannot specify both state and LGA
#' get_abs_household_size_distribution(state = "NSW", lga = "Fairfield (C)")
#' }
get_abs_household_size_distribution <- function(state = NULL, lga = NULL) {
  level <- dplyr::case_when(
    is.null(state) & is.null(lga) ~ "national",
    !is.null(state) & is.null(lga) ~ "state",
    is.null(state) & !is.null(lga) ~ "lga",
    TRUE ~ "erroneous"
  )

  if (level == "erroneous") {
    abort("only one of state and lga may be specified")
  }

  if (length(state) > 1 | length(lga) > 1) {
    abort("only one state or LGA at a time, please")
  }

  if (!is.null(state)) {
    check_state_name(state)
  }

  if (!is.null(lga)) {
    check_lga_name(lga)
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
    ) %>%
    dplyr::select(-c(n_persons_usually_resident, n_households)) %>%
    dplyr::rename(household_size = size)

  state <- rlang::enquo(state)
  lga <- rlang::enquo(lga)

  # set up aggregation
  household_data <- switch(level,
    national = household_data,
    state = household_data %>%
      dplyr::filter(state == !!state) %>%
      dplyr::group_by(state),
    lga = household_data %>%
      dplyr::filter(lga == !!lga) %>%
      dplyr::group_by(lga)
  )

  if (nrow(household_data) == 0) {
    cli::cli_abort(
      "{level} '{paste(get(level))[2]}' not found"
    )
  }
  household_data
}
