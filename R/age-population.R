#' @title Get cleaned population data with lower and upper limits of age.
#'
#' @description This function helps clean up datasets of population data, which
#'   might be similar to `socialmixr::wpp_age()` or a dataset with columns
#'   representing: population, location, age, and year. If age is numeric, it
#'   groups ages into age groups with 5 year bins (0-4, 5-9, etc). It then
#'   separates age groups into two column of these lower and upper limits.
#'   Finally, it filters data passed to the specified year and location. If no
#'   year or location is provided then all years or locations are used.

#' @param data dataset containing information on population for a given age,
#'   country, and year
#' @param age_col bare variable name for the column with age information
#' @param location_col bare variable name for the column with location
#'   information. If using, both `location_col` & `location` must be specified.
#' @param location character vector with location names. If using, both
#'   `location_col` & `location` must be specified.
#' @param year_col bare variable name for the column with year information. If
#'   using, both `year_col` & `year` must be specified.
#' @param year numeric vector representing the desired year(s). If using, both
#'   `year_col` & `year` must be specified.
#' @return tidy dataset with information on population of different age bands
#' @export
#' @examples
#' world_data <- socialmixr::wpp_age()
#' world_data
#' # Tidy data for multiple locations across different years
#' age_population(
#'   data = world_data,
#'   location_col = country,
#'   location = c("Asia", "Afghanistan"),
#'   age_col = lower.age.limit,
#'   year_col = year,
#'   year = c(2010:2020)
#' )
#'
#' # Tidy data for a given location irrespective of year
#' age_population(
#'   data = world_data,
#'   location_col = country,
#'   location = "Afghanistan",
#'   age_col = lower.age.limit
#' )
#'
#' # Tidy data for a given location irrespective of location
#' age_population(
#'   data = world_data,
#'   age_col = lower.age.limit
#' )
#' age_population(
#'   data = world_data,
#'   age_col = lower.age.limit,
#'   year_col = year,
#'   year = c(2011:2015)
#' )
#'
#' # Tidy datasets with age groups
#' population_age_groups <- abs_pop_age_lga_2020
#' population_age_groups
#' age_population(
#'   data = population_age_groups,
#'   age_col = age_group,
#'   year_col = year,
#'   year = 2020
#' )
#'
#' # Tidy datasets with numeric age
#' population_numeric_age <- abs_age_state("WA")
#' population_numeric_age
#' age_population(
#'   data = population_numeric_age,
#'   age_col = lower.age.limit,
#'   year_col = year,
#'   year = 2020
#' )
#'
age_population <- function(data,
                           location_col = NULL,
                           location = NULL,
                           age_col,
                           year_col = NULL,
                           year = NULL) {
  # checks the data type of age col and puts age into buckets if its numeric
  # which gets separated later as lower and upper limits

  age_var <- dplyr::pull(data, {{ age_col }})

  if (is.numeric(age_var)) {
    label <- c(paste(
      seq(0, max(age_var), by = 5),
      seq(0 + 5 - 1, max(age_var) + 5 - 1, by = 5),
      sep = "-"
    ))

    data <- data %>%
      dplyr::mutate(
        age_group = cut(
          {{ age_col }},
          breaks = c(seq(0, max(age_var), by = 5), Inf),
          labels = label,
          right = FALSE
        )
      )

    age_population_df <- clean_age_population_year(
      data = data,
      location_col = {{ location_col }},
      location = {{ location }},
      age_col = age_group,
      year_col = {{ year_col }},
      year = {{ year }}
    )
  } else {
    age_population_df <- clean_age_population_year(
      data = data,
      location_col = {{ location_col }},
      location = {{ location }},
      age_col = {{ age_col }},
      year_col = {{ year_col }},
      year = {{ year }}
    )
  }
  age_population_df <- conmat_population(
    data = age_population_df,
    age = lower.age.limit,
    population = population
  )
  return(age_population_df)
}
