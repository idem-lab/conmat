#' @title Check LGA name in Australia
#' @param lga_name a string denoting the official name of Local Government Area.
#'   For example, 'Albury (C).'
#' @param multiple_lga logical response that allows multiple lgas to be checked
#'   if set to `TRUE`. Default is FALSE.
#' @return errors if LGA name not in ABS data, otherwise returns nothing
#' @examples 
#' # returns nothing
#' check_lga_name("Fairfield (C)")
#' # if you want to check multiple LGAs you must use the `multiple_lga` flag.
#' check_lga_name(lga_name = c("Fairfield (C)", "Sydney (C)"), 
#'                multiple_lga = TRUE)
#' # this will error, so isn't run
#' \dontrun{
#' # don't set the `multiple_lga` flag
#' check_lga_name(lga_name = c("Fairfield (C)", "Sydney (C)"))
#' # not a fully specified LGA
#' check_lga_name("Fairfield")
#' }
#' @export
check_lga_name <- function(
    lga_name,
    multiple_lga = FALSE
) {
  lga_match <- dplyr::filter(
    abs_pop_age_lga_2020,
    lga %in% lga_name
  )
  
  does_lga_match <- nrow(lga_match) > 1
  
  if (!does_lga_match) {
    rlang::abort(
      message = c(
        "The LGA name provided does not match LGAs in Australia",
        x = glue::glue("The lga name '{lga_name}' did not match (it probably \\
                       needs '{lga_name} (C)' or similar"),
        i = "See `abs_lga_lookup` for a list of all LGAs"
      )
    )
  }
  
  if (does_lga_match) {
    unique_lga_names <- abs_pop_age_lga_2020 %>%
      dplyr::filter(lga %in% lga_name) %>%
      dplyr::pull(lga) %>%
      unique()
    
    more_than_one_lga <- length(unique_lga_names) > 1
    
    if (more_than_one_lga & !multiple_lga) {
      rlang::abort(
        message = c(
          "The LGA name provided matches multiple LGAs",
          i = "Specify the exact LGA name or set {.arg {multiple_lga}} = \\
          `TRUE`. See {.code {abs_lga_lookup}} for a list of all LGAs",
          x = glue::glue("The lga name '{lga_name}' matched multiple LGAs:"),
          glue::glue("{unique_lga_names}")
        )
      )
    } # end if there is more than one matching LGA
  } # end if LGA matches
} # end function

#' @title Check state name in Australia
#' @param state_name character of length 1
#' @return errors if state name not in ABS data
#' @keywords internal
#' @noRd
check_state_name <- function(state_name, multiple_state = FALSE) {
  state_that_matches <-  abs_pop_age_lga_2020 %>%
    dplyr::select(state) %>%
    dplyr::distinct() %>%
    dplyr::filter(state %in% state_name) %>%
    dplyr::pull(state)
  
  state_match <- is.element(state_name, state_that_matches)
  
  all_match <- all(state_match)
  state_that_doesnt_match <- setdiff(state_name, state_that_matches)
  
  
  if (!all_match) {
    rlang::abort(
      message = c(
        "The state name provided does not match states in Australia",
        x = glue::glue("The state name '{state_that_doesnt_match}' did not match"),
        i = "See `abs_lga_lookup` for a list of all states"
      )
    )
  }
  more_than_one_state <- length(state_that_matches) > 1
  if (more_than_one_state & !multiple_state) {
    rlang::abort(
      message = c(
        "The state name provided matches multiple states",
        i = "Specify the exact state name or set {.arg {multiple_state}} = \\
          `TRUE`. See {.code {abs_lga_lookup}} for a list of all states",
        x = glue::glue("The state name '{state_name}' matched multiple states:"),
        glue::glue("{ state_that_matches}")
      )
    )
  }
}

