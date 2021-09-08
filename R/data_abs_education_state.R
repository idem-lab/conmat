#' ABS education by state for 2006-2020
#'
#' A dataset containing Australian Bureau of Statistics education data by
#'   state for 2006 to 2020
#'
#' @format A data frame with 4194 rows and 5 variables:
#' \describe{
#'   \item{year}{year - 2020}
#'   \item{state}{state - short state or territory name}
#'   \item{aboriginal_and_torres_strait_islander_status}{"Aboriginal and Torres Strait Islander" or  "Non-Indigenous"}
#'   \item{age}{4 through to 21. Note that "4" is 4 or younger and "21" is actually 21+ (21 or older)}
#'   \item{n_full_and_part_time}{number of people full and part time}
#' }
#' @source \url{https://www.abs.gov.au/statistics/people/education/schools/2020#data-download} (table 42B)
"abs_education_state"
