#' @title Check LGA name in Australia
#' @param lga_name a string denoting the official name of Local Government Area.
#'   For example, 'Albury (C).'
#' @param multiple_lga logical response that allows multiple lgas to be checked
#'   if set to `TRUE`. Default is FALSE.
#' @return errors if LGA name not in ABS data
#' @keywords internal
#' @noRd
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
check_state_name <- function(state_name) {
  state_match <- stringr::str_detect(
    string = abs_pop_age_lga_2020$state,
    pattern = state_name
  )
  
  does_state_match <- !any(state_match)
  
  if (does_state_match) {
    rlang::abort(
      message = c(
        "The state name provided does not match states in Australia",
        x = glue::glue("The state name '{state_name}' did not match"),
        i = "See `abs_lga_lookup` for a list of all states"
      )
    )
  }
}


check_if_only_one_null <- function(x, y){
  x_null <- is.null(x)
  y_null <- is.null(y)
  null_sum <- x_null + y_null
  no_null <- null_sum == 0
  one_null <- null_sum == 1
  both_null <- null_sum == 2
  
  if (no_null){
    return()
  } 
  
  if (both_null){
    return()
  }
  
  if (one_null) {
    msg <- cli::format_error(
      c(
        "Both variables need to be specified, only one is",
        "i" = "{.var x} is {ifelse(is.null(x), 'NULL', x)}",
        "i" = "{.var y} is {ifelse(is.null(y), 'NULL', y)}",
        "You are seeing this error message because you need to specify both \\
        of {.var location_col} & {.var location}, or {.var year_col} & \\
        {.var year} as either NULL or with values"
      )
      
    )
    stop(
      msg,
      call. = FALSE
    )
  }
  
}