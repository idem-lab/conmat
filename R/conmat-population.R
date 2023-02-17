#' Create a new `conmat_population` class object
#'
#' @param data data.frame
#' @param age bare column name of numeric data on age
#' @param population bare column name of numeric data on population
#'
#' @return object with class `conmat_population`
#' @keywords internal
new_conmat_population <- function(data, age, population) {
  label_age <- as_name(age)
  label_population <- as_name(population)
  tibble::new_tibble(
    data,
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
#'   to this information throughout other functions in the conmat package
#'   without needing to specify or hard code which columns represent the age
#'   and population information.
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

#' @title Convert to conmat population
#' @param data data.frame
#' @param ... extra arguments
#' @name as_conmat_population
#'
#' @export
as_conmat_population <- function(data, ...) {
  UseMethod("as_conmat_population")
}

#' @rdname as_conmat_population
#' @export
as_conmat_population.default <- function(data, ...) {
  abort("Cannot currently convert object of class {.cls {class(data)}} into \\
        a {.cls conmat_population} object.")
}

#' @param age age column - an unquoted variable of numeric integer ages
#' @param population population column - an unquoted variable, numeric value
#' @rdname as_conmat_population
#' @export
#' @examples
#' some_age_pop <- data.frame(
#'   age = 1:10,
#'   pop = 101:110
#' )
#'
#' some_age_pop
#'
#' as_conmat_population(
#'   some_age_pop,
#'   age = age,
#'   population = pop
#' )
as_conmat_population.data.frame <- function(data, age, population, ...) {
  # strip any existing classes
  data <- as.data.frame(data)
  age <- enquo(age)
  population <- enquo(population)
  conmat_population(
    data = data,
    age = !!age,
    population = !!population
  )
}

#' @rdname as_conmat_population
#' @export
as_conmat_population.list <- as_conmat_population.data.frame

#' @rdname as_conmat_population
#' @export
as_conmat_population.grouped_df <- as_conmat_population.data.frame

#' @keywords internal
#' @export
as_conmat_population.NULL <- function(data, ...) {
  abort("A {conmat_population} must not be NULL")
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

#' @export
print.conmat_population <- function(x, ...) {
  txt <- glue::glue("({class(x)[[1]]})")
  out <- cli::col_red(txt)
  age_txt <- glue::glue(
    "- age: {cli::style_bold(age_label(x))}"
  )
  population_txt <- glue::glue(
    "- population: {cli::style_bold(population_label(x))}"
  )
  age_out <- cli::col_grey(age_txt)
  population_out <- cli::col_grey(population_txt)
  # adds to the top of the tibble
  msg <- sprintf(
    "%s %s\n %s\n %s\n", format(x)[1], out,
    age_out,
    population_out
  )
  cat(msg)
  cli::cat_line(format(x)[-1])
}
