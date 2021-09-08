#' ABS population by age for 2016 for LGAs
#'
#' A dataset containing Australian Bureau of Statistics population data by
#'   local government area (LGA) for age for 2016
#'
#' @format A data frame with 9918 rows and 6 variables:
#' \describe{
#'   \item{year}{year - 2020}
#'   \item{state}{state - short state or territory name}
#'   \item{lga}{LGA name}
#'   \item{age_group}{age age band, 0-4, in 5 year increments up to 80-84, then 85+}
#'   \item{population}{number of people in a given lga in an age band}
#' }
#' @source \url{https://www.abs.gov.au/statistics/people/population/regional-population-age-and-sex}
"abs_pop_age_lga_2016"
