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
#' @return data frame with `lower.age.limit` and `upper.age.limit` and
#'   optionally filtered down to specific location or year.
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

print_list_dim <- function(x, object_class) {
  dim_char <- purrr::map_chr(
    x,
    ~ paste(scales::comma(dim(.x)), collapse = "x")
  )
  names_x <- glue::glue(
    "{.strong [names(dim_char)]}: a [dim_char] {.cls [object_class]}",
    .open = "[",
    .close = "]"
  )
  cli::cli_li(names_x)
}

print_model_info <- function(x, object_class) {
  dim_char <- purrr::map_chr(
    x,
    ~ scales::comma(summary(.x)$n)
  )
  names_x <- glue::glue(
    "{.strong [names(dim_char)]}: a {.cls [object_class]} model ([dim_char] obs)",
    .open = "[",
    .close = "]"
  )
  cli::cli_li(names_x)
}

print_setting_info <- function(x,
                               heading,
                               description = NULL,
                               list_print_fun = print_list_dim(x, object_class),
                               object_class) {
  age_breaks <- age_breaks(x)
  cli::cli_h1(heading)
  cli::cat_line()
  cli::cli_text(cli::style_italic(description))
  cli::cat_line()
  print_age_breaks(age_breaks)
  cli::cat_line()

  list_print_fun

  cli::cli_alert_info(
    "Access each {.cls {object_class}} with {.code x$name}"
  )
  cli::cli_alert_info("e.g., {.code x${names(x)[1]}}")
  return(invisible(x))
}

#' @export
print.conmat_age_matrix <- function(x, ...) {
  # remove class and attributes in printing as they
  # appear at the end of the object when printing
  x_copy <- x
  attr(x_copy, "age_breaks") <- NULL
  print(unclass(x_copy))
  return(invisible(x))
}

#' @export
print.conmat_setting_prediction_matrix <- function(x, ...) {
  print_setting_info(
    x = x,
    heading = "Setting Prediction Matrices",
    description = "A list of matrices containing the model predicted contact rate between ages in each setting.",
    object_class = "matrix"
  )
}

#' @export
print.ngm_setting_matrix <- function(x, ...) {
  print_setting_info(
    x = x,
    heading = "NGM Setting Matrices",
    description = "A list of matrices, each {.cls matrix} containing the number of newly infected individuals for a specified age group.",
    object_class = "matrix"
  )
}

#' @export
print.setting_vaccination_matrix <- function(x, ...) {
  print_setting_info(
    x = x,
    heading = "Vaccination Setting Matrices",
    description = "A list of matrices, each {.cls matrix} containing the {.strong adjusted} number of newly infected individuals for age groups. These numbers have been adjusted based on proposed vaccination rates in age groups",
    object_class = "matrix"
  )
}

#' @export
print.transmission_probability_matrix <- function(x, ...) {
  print_setting_info(
    x = x,
    heading = "Transmission Probability Matrices",
    description = "A list of matrices, each {.cls matrix} containing the {.strong relative} probability of individuals in a given age group infecting an individual in another age group, for that setting.",
    object_class = "matrix"
  )
}

#' @export
print.setting_contact_model <- function(x, ...) {
  print_setting_info(
    x = x,
    heading = "Fitted Setting Contact Models",
    description = "A list of fitted {.cls bam} models for each setting. Each {.cls bam} model predicts the contact rate between ages, for that setting.",
    list_print_fun = print_model_info(x, "bam"),
    object_class = "bam"
  )
}

#' @export
print.setting_data <- function(x, ...) {
  print_setting_info(
    x = x,
    heading = "Setting Data",
    description = "A list of {.cls data.frame}s containing the number of contacts between ages in each setting.",
    object_class = "data.frame"
  )
}

group_age_breaks <- function(x) {
  from <- stats::na.omit(dplyr::lag(x))
  to <- stats::na.omit(dplyr::lead(x))
  glue::glue("[{from},{to})")
}

ungroup_age_breaks <- function(x) {
  strsplit(
    x = x,
    # remove , and ) and [
    split = ",|\\)|\\["
  ) %>%
    unlist() %>%
    as.numeric() %>%
    stats::na.omit() %>%
    unique() %>%
    sort()
}
#
# group_age_breaks(1:10, pad_inf = FALSE)
# group_age_breaks(1:10, pad_inf = FALSE) %>% ungroup_age_breaks()
# group_age_breaks(1:10, pad_inf = TRUE)
# group_age_breaks(1:10, pad_inf = TRUE) %>% ungroup_age_breaks()
#
# group_age_breaks(c(1:10, Inf), pad_inf = TRUE)
# group_age_breaks(c(1:10, Inf), pad_inf = TRUE) %>% ungroup_age_breaks()
#
# group_age_breaks(c(1:10, Inf), pad_inf = FALSE)
# group_age_breaks(c(1:10, Inf), pad_inf = FALSE) %>% ungroup_age_breaks()
#
# group_age_breaks(age_breaks_0_80_plus)
# group_age_breaks(1:10, pad_inf = FALSE)
# group_age_breaks(1:9, pad_inf = FALSE)
# group_age_breaks(1:8, pad_inf = FALSE)
# group_age_breaks(1:10)
# group_age_breaks(1:9)
# group_age_breaks(1:8)

all_matrix <- function(x) {
  all(vapply(
    X = x,
    inherits,
    what = "matrix",
    FUN.VALUE = logical(1)
  ))
}

name_list <- function(list) {
  n_list <- length(list)
  names(list) <- english::english(seq_len(n_list))
  list
}


repair_list_matrix_names <- function(list_matrix) {
  if (is.null(names(list_matrix))) {
    list_matrix <- name_list(list_matrix)
  }
  list_matrix
}

prepare_list_matrix <- function(...) {
  list_matrix <- list(...)
  check_if_all_matrix(list_matrix)

  # do something if ... doesn't have any names
  repair_list_matrix_names(list_matrix)
}

add_all_setting <- function(list_matrix) {
  if (!("all" %in% names(list_matrix))) {
    list_matrix$all <- Reduce("+", list_matrix)
  }
  list_matrix
}

set_age_breaks_matrix <- function(matrix, age_breaks) {
  dimnames(matrix) <- list(
    group_age_breaks(age_breaks),
    group_age_breaks(age_breaks)
  )
  matrix
}

set_age_breaks_matrices <- function(list_matrix, age_breaks) {
  lapply(
    list_matrix,
    set_age_breaks_matrix,
    age_breaks
  )
}

# age_breaks(perth_contact_0_75)

remove_inf <- function(x) {
  x_inf <- is.infinite(x)
  if (!any(x_inf)) {
    return(x)
  } else if (any(x_inf)) {
    inf_index <- which(x_inf)
    return(x[-inf_index])
  }
}

is_equally_spaced <- function(x) {
  double_diff <- remove_inf(x) %>%
    diff() %>%
    diff()
  all(double_diff == 0)
}

age_interval <- function(x) {
  if (is_equally_spaced(x)) {
    age_int <- remove_inf(x) %>%
      diff() %>%
      unique()
  } else if (!is_equally_spaced(x)) {
    age_int <- remove_inf(x) %>%
      diff() %>%
      mean() %>%
      round(2)
  }
  age_int
}

print_age_breaks <- function(age_breaks) {
  has_inf <- any(is.infinite(age_breaks))
  n_age_breaks <- length(age_breaks) - 1
  age_range <- range(age_breaks, finite = TRUE)
  min_age <- age_range[1]
  max_age <- age_range[2]

  equally_spaced <- is_equally_spaced(age_breaks)
  year_gap <- age_interval(age_breaks)

  if (has_inf) {
    age_info <- glue::glue("There are {n_age_breaks} age breaks, ranging {min_age}-{max_age}+ years, ")
  } else if (!has_inf) {
    age_info <- glue::glue("There are {n_age_breaks} age breaks, ranging {min_age}-{max_age} years, ")
  }
  if (equally_spaced) {
    age_gap_info <- glue::glue("with a regular {year_gap} year interval")
  } else if (!equally_spaced) {
    age_gap_info <- glue::glue("with an irregular year interval, (on average, {year_gap} years)")
  }

  cli::cli_text(
    cli::style_italic(
      age_info,
      age_gap_info
    )
  )
}
