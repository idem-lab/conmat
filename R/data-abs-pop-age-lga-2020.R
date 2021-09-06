#' ABS population by age for 2020 for LGAs
#'
#' A dataset containing Australian Bureau of Statistics population data by 
#'   local government area (LGA) for age for 2020
#'
#' @format A data frame with 9900 rows and 6 variables:
#' \describe{
#'   \item{year}{year - 2020}
#'   \item{state}{state - long state or territory name}
#'   \item{lga_code}{code number for LGA}
#'   \item{lga_name}{LGA name}
#'   \item{age}{age band, 0-4, in 5 year increments up to 80-84, then 85+}
#'   \item{population}{number of people in a given lga in an age band}
#' }
#' @source \url{https://www.abs.gov.au/statistics/people/population/regional-population-age-and-sex}
"abs_pop_age_lga_2020"