#' @title Get per capita household size based on state or LGA name
#' @param state state name
#' @param lga lga name
#' @return Numeric of length 1 - the per capita household size for a given state
#'     or LGA.
#' @author Nick Golding
#' @export
#' @examples
#' get_abs_per_capita_household_size(lga = "Fairfield (C)")
#' get_abs_per_capita_household_size(state = "NSW")
#' \dontrun{
#' # cannot specify both state and LGA
#' get_abs_per_capita_household_size(state = "NSW", lga = "Fairfield (C)")
#' }
get_abs_per_capita_household_size <- function(state = NULL, lga = NULL) {
  level <- dplyr::case_when(
    is.null(state) & is.null(lga) ~ "national",
    !is.null(state) & is.null(lga) ~ "state",
    is.null(state) & !is.null(lga) ~ "lga",
    TRUE ~ "erroneous"
  )

  if (level == "erroneous") {
    rlang::abort("only one of state and lga may be specified")
  }

  if (length(state) > 1 | length(lga) > 1) {
    rlang::abort("only one state or LGA at a time, please")
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
    cli::cli_abort(
      "{level} '{paste(get(level))[2]}' not found"
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
      per_capita_household_size = sum(size * fraction),
      .groups = "drop"
    ) %>%
    dplyr::pull(
      per_capita_household_size
    )
}
