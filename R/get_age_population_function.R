#' @title Return an interpolating function for populations in 1y age increments
#'
#' @description This function returns an interpolating function to get
#'   populations in 1y age increments from chunkier distributions produced by
#'   `socialmixr::wpp_age()`.
#'
#' @param data dataset containing information on population of a given
#'   age/age group
#' @param ... extra arguments
#'
#' @details The function first prepares the data to fit a smoothing spline to
#'  the data for ages below the maximum age. It arranges the data by the lower
#'  limit of the age group to obtain the bin width/differences of the lower
#'  age limits. The mid point of the bin width is later added to the ages and
#'  the population is scaled as per the bin widths. The maximum age is later
#'  obtained and the populations for different above and below are filtered out
#'  along with the sum of populations with and without maximum age. A cubic
#'  smoothing spline is then fitted to the data for ages below the maximum with
#'  predictor variable as the ages with the mid point of the bins added to it
#'  where as the response variable is the log-scaled population. Using the
#'  smoothing spline fit, the predicted population of ages 0 to 200 is obtained
#'  and the predicted population is adjusted further using a ratio of the sum
#'  of the population across all ages from the data and predicted population.
#'  The ratio is based on whether the ages are under the maximum age as the
#'  total population across all ages differs for ages above and below the
#'  maximum age. The maximum age population is adjusted further to drop off
#'  smoothly, based on the weights. The final population is then linearly
#'  extrapolated over years past the upper bound from the data. For ages above
#'  the maximum age from data, the population is calculated as a weighted
#'  population of the maximum age that depends on the years past the upper
#'  bound. Older ages would have lower weights, therefore lower population.
#'
#' @return An interpolating function to get populations in 1y age increments
#' @examples
#' polymod_pop <- get_polymod_population()
#'
#' polymod_pop
#'
#' # But these ages and populations are binned every 5 years. So we can now
#' # provide a specified age and get the estimated population for that 1 year
#' # age group. First we create the new function like so
#'
#' age_pop_function <- get_age_population_function(
#'   data = polymod_pop
#' )
#' # Then we pass it a year to get the estimated population for a particular age
#' age_pop_function(4)
#'
#' # Or a vector of years, to get the estimated population for a particular age
#' # range
#' age_pop_function(1:4)
#'
#' # Notice that we get a _pretty similar_ number of 0-4 if we sum it up, as
#' # the first row of the table:
#' head(polymod_pop, 1)
#' sum(age_pop_function(age = 0:4))
#'
#' # Usage in dplyr
#' library(dplyr)
#' example_df <- slice_head(abs_education_state, n = 5)
#' example_df %>%
#'   mutate(population_est = age_pop_function(age))
#'
#' @export
#' @rdname get_age_population_function
get_age_population_function <- function(data, ...) {
  UseMethod("get_age_population_function")
}

#' @name get_age_population_function
#' @export
get_age_population_function.conmat_population <- function(
  data = population,
  ...
) {
  # prepare population data for modelling
  pop_model <- prepare_population_for_modelling(
    data = data
  )

  return_age_population_function(pop_model)
}

#' @param age_col bare variable name for the column with age information
#' @param pop_col bare variable name for the column with population information
#' @name get_age_population_function
#' @export
get_age_population_function.data.frame <- function(
  data = population,
  age_col = lower.age.limit,
  pop_col = population,
  ...
) {
  # prepare population data for modelling
  pop_model <- prepare_population_for_modelling(
    data = data,
    age_col = age_col,
    pop_col = pop_col
  )

  return_age_population_function(pop_model)
}
