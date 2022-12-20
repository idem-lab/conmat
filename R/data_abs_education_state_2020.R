#' @title 2020 ABS education population data, interpolated into 1 year bins,
#'   by state.
#'
#' @description A dataset containing Australian Bureau of Statistics education
#'   data by state for 2020. These were interpolated into 1 year age bins.
#'   There are still some issued with the methods used, as the interpolated
#'   values are sometimes higher than the population.
#'
#' @format A data frame with 808 rows and 6 variables:
#' \describe{
#'   \item{year}{year - 2020}
#'   \item{state}{state - short state or territory name}
#'   \item{age}{0 to 100}
#'   \item{population}{number of people full and part time}
#'   \item{population_interpolated}{"Government" or "Non-government"}
#'   \item{prop}{population / population_interpolated}
#' }
#' @source \url{https://www.abs.gov.au/statistics/people/education/schools/2020#data-download} (table 42B)
"abs_education_state_2020"
