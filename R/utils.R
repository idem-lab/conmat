#' Prepare age population data
#'
#' Internally used function within [age_population()] to separate age groups
#'   into its lower & upper limit and then filter the data passed to the desired
#'   year and location.
#'
#' @param data data.frame
#' @param location_col bare unquoted variable referring to location column
#' @param location location name to filter to. If not specified gives all locations.
#' @param age_col bare unquoted variable referring to age column
#' @param year_col bare unquoted variable referring to year column
#' @param year year to filter to. If not specified, gives all years.
#'
#' @keywords internal
#'
#' @return data frame with lower.age.limit and upper.age.limit and optionally
#'   filtered down to specific location or year.
clean_age_population_year <- function(data,
                                      location_col = NULL,
                                      location = NULL,
                                      age_col,
                                      year_col = NULL,
                                      year = NULL) {
  # separate age group into "lower.age.limit" & "upper.age.limit"
  age_population_year_df <- separate_age_group(data, {{ age_col }})

  # filter year only

  if (!is.null(year)) {
    age_population_year_df <- age_population_year_df %>%
      dplyr::filter({{ year_col }} %in% {{ year }})
  }

  # filter year & location
  if (!is.null(location)) {
    age_population_location_df <- age_population_year_df %>%
      dplyr::filter({{ location_col }} %in% {{ location }})

    return(age_population_location_df)
  } else {
    return(age_population_year_df)
    # return the whole data frame or the df with only year filter
    # if year variable is present
  }
}

#' Separate age groups
#'
#' An internal function used within [clean_age_population_year()] to
#'   separate age groups in a data set into two variables, `lower.age.limit`,
#'   and `upper.age.limit`
#'
#' @param data data frame
#' @param age_col bare unquoted column referring to age column
#' @keywords internal
#' @return data frame with two extra columns, `lower.age.limit` and
#'   `upper.age.limit`
separate_age_group <- function(data, age_col) {
  result <- data %>%
    tibble::as_tibble() %>%
    tidyr::separate(
      {{ age_col }},
      c("lower.age.limit", "upper.age.limit"),
      "[[:punct:]]",
      extra = "merge"
    ) %>%
    dplyr::mutate(
      across(
        .cols = c(lower.age.limit, upper.age.limit),
        .fns = function(x) readr::parse_number(as.character(x))
      )
    )

  result
}

#' @title Return the widths of bins denoted by a sequence of lower bounds
#' @description Return the widths of bins denoted by a sequence of lower
#'   bounds (assuming the final is the same as the `[penultimate]`).
#' @param lower_bound lower bound value - a numeric vector
#' @return vector
#' @author Nick Golding
#' @keywords internal
#' @noRd
bin_widths <- function(lower_bound) {
  # return the widths of bins denoted by a sequence of lower bounds (assumming
  # the final is the same as the [penultimate])
  diffs <- diff(lower_bound)
  c(diffs, diffs[length(diffs)])
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

  #   lapply(ngm, "ncol") %>%
  #     mapply(nrow(data), FUN = "identical") %>%
  #     all()

  if (!dim_match) {
    stop(cli::format_error(
      c(
        "Non-conformable arrays present.",
        "i" = "The number of columns in {.var ngm} must match the number of rows in {.var data}.",
        "x" = "Number of columns in {.var ngm} for the settings: {names(ngm)} are {purrr::map_int(ngm, ncol)} respectively.",
        "x" = "Number of rows in {.var data} is {nrow(data)}."
      )
    ))
  }
}

#'
#' @title Check if data is a list
#' @param contact_data data on the contacts between two ages at different settings
#' @keywords internal
check_if_list <- function(contact_data) {
  if (!inherits(contact_data, "list")) {
    stop(cli::format_error(
      c(
        "i" = "Function expects {.var contact_data} to be of class {.cls list}",
        "x" = "We see {.var contact_data} is of class {.cls {class(contact_data)}}."
      )
    ))
  }
}

#' @export
print.conmat_prediction_matrix <- function(x, ...) {
  print(unclass(x), ...)
  return(invisible(x))
}

#' @export
print.conmat_setting_prediction_matrix <- function(x, ...) {
  n_matrices <- length(names(x))
  cli::cli_h1("Setting Prediction Matrices:")
  dim_char <- purrr::map_chr(
    x,
    ~ paste(dim(.x), collapse = "x")
  )
  names_x <- glue::glue(
    "{.strong [names(dim_char)]}: {.val [dim_char]} matrix",
    .open = "[",
    .close = "]"
  )
  cli::cli_li(names_x)
  cli::cli_alert_info("Access each matrix with {.code x$name}")
  cli::cli_alert_info("e.g., {.code x${names(x)[1]}}")
  # print(unclass(x), ...)
  return(invisible(x))
}
