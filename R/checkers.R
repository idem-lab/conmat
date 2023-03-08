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
#' check_lga_name(
#'   lga_name = c("Fairfield (C)", "Sydney (C)"),
#'   multiple_lga = TRUE
#' )
#' # this will error, so isn't run
#' \dontrun{
#' # don't set the `multiple_lga` flag
#' check_lga_name(lga_name = c("Fairfield (C)", "Sydney (C)"))
#' # not a fully specified LGA
#' check_lga_name("Fairfield")
#' }
#' @keywords internal
#' @noRd
check_lga_name <- function(lga_name,
                           multiple_lga = FALSE) {
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
  state_that_matches <- abs_pop_age_lga_2020 %>%
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


#' @title Check dimensions
#' @description An internal function used within [apply_vaccination()] to warn users of incompatible dimensions of
#' data and the next generation matrices
#'
#' @param data data frame
#' @param ngm  list with next generation matrices at different settings
#' @keywords internal
check_dimensions <- function(ngm, data) {
  nrow_data <- nrow(data)
  ngm_cols <- purrr::map_int(ngm, ncol)
  dim_match <- all(nrow_data == ngm_cols)

  if (!dim_match) {
    cli::cli_abort(
      c(
        "Non-conformable arrays present.",
        "i" = "The number of columns in {.var ngm} must match the number of rows in {.var data}.",
        "x" = "Number of columns in {.var ngm} for the settings: {names(ngm)} are {purrr::map_int(ngm, ncol)} respectively.",
        "x" = "Number of rows in {.var data} is {nrow(data)}."
      )
    )
  }
}

check_if_var_numeric <- function(data, var, attribute) {
  var_val <- data[[var]]

  if (!is.numeric(var_val)) {
    cli::cli_abort(
      c(
        "{.var {attribute}} must be {.cls numeric}",
        "{.var {var_lab}} has been entered to represent {.var {attribute}}",
        "But {.var {var_lab}} is of class {.cls {class(var_val)}}"
      )
    )
  }
}

check_if_data_frame <- function(x) {
  if (!is.data.frame(x)) {
    cli::cli_abort(
      c(
        "x must be a {.cls data.frame}",
        i = "x is {.cls {class(x)}}"
      )
    )
  }
}

error_old_ngm_arg <- function(arg) {
  cli::cli_abort(
    c(
      "{arg} is no longer used in {.code generate_ngm}",
      i = "Please use {.code generate_ngm_oz} instead"
    )
  )
}


#'
#' @title Check if data is a list
#' @param contact_data data on the contacts between two ages at different settings
#' @keywords internal
check_if_list <- function(contact_data) {
  if (!inherits(contact_data, "list")) {
    cli::cli_abort(
      c(
        "i" = "Function expects {.var contact_data} to be of class {.cls list}",
        "x" = "We see {.var contact_data} is of class {.cls {class(contact_data)}}."
      )
    )
  }
}

check_if_all_matrix <- function(x) {
  if (!all_matrix(x)) {
    cli::cli_abort(
      c("Inputs must all be of class {.cls matrix}")
    )
  }
}

check_age_breaks <- function(x,
                             y,
                             x_arg = "old",
                             y_arg = "new") {
  if (!identical(x, y)) {
    compare_res <- waldo::compare(
      x = x,
      y = y,
      x_arg = x_arg,
      y_arg = y_arg
    )

    rlang::abort(
      c(
        "Age breaks must be the same, but they are different:",
        compare_res,
        i = "You can check the age breaks using `age_breaks(<object>)`"
      )
    )
  }
}
