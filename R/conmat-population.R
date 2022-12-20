new_conmat_population <- function(data, age, population) {
  label_age <- as_name(age)
  label_population <- as_name(population)

  tibble::new_tibble(data,
    nrow = vctrs::vec_size(data),
    "age" = label_age,
    "population" = label_population,
    class = "conmat_population"
  )
}

validate_conmat_population <- function(x) {
  check_if_data_frame(x)
  check_if_var_numeric(x, age_label(x), "age")
  check_if_var_numeric(x, population_label(x), "population")
}

#' Define a conmat population
#'
#' A conmat population is a dataframe that stores which columns represent the
#'   age and population information. This is useful as it means we can refer
#'   to this information throughout other functions in the package without
#'   needing to specify or hard code which columns represent the age and
#'   population information.
#'
#' @param data data.frame
#' @param age bare name representing the age column
#' @param population bare name representing the population column
#'
#' @return a data frame with age and population attributes
#' @export
#'
#' @examples
#' perth <- abs_age_lga("Perth (C)")
conmat_population <- function(data, age, population) {
  population <- new_conmat_population(
    data = data,
    age = enquo(age),
    population = enquo(population)
  )
  validate_conmat_population(population)
  population
}

#' Accessing conmat attributes
#'
#' @param x conmat_population data frame
#'
#' @return age or population symbol or label
#'
#' @rdname accessors
#' @examples
#' \dontrun{
#' perth <- abs_age_lga("Perth (C)")
#' age(perth)
#' age_label(perth)
#' population(perth)
#' population_label(perth)
#' }
#' @export
age <- function(x) {
  sym(age_label(x))
}

#' @rdname accessors
#' @export
age_label <- function(x) {
  UseMethod("age_label")
}

#' @rdname accessors
#' @export
age_label.default <- function(x) {
  cli::cli_abort("Cannot access {.val age} information from class \\
                 {.cls {class(x)}}")
}

#' @rdname accessors
#' @export
age_label.conmat_population <- function(x) {
  x %@% "age"
}

#' @rdname accessors
#' @export
population_label <- function(x) {
  UseMethod("population_label")
}

#' @rdname accessors
#' @export
population_label.default <- function(x) {
  cli::cli_abort("Cannot access {.val population} information from class \\
        {.cls {class(x)}")
}

#' @rdname accessors
#' @export
population_label.conmat_population <- function(x) {
  x %@% "population"
}

#' @rdname accessors
#' @export
population <- function(x) {
  sym(population_label(x))
}
