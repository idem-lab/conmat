#' ABS education by state for 2006-2020
#'
#' A dataset containing Australian Bureau of Statistics education data by
#'   state for 2006 to 2020
#'
#' @format A data frame with 4194 rows and 5 variables:
#' \describe{
#'   \item{year}{year - 2020}
#'   \item{state}{state - short state or territory name}
#'   \item{age}{4- (4 or younger, then 1 year increments to 20, then 21+ (21 or older)}
#'   \item{n_full_and_part_time}{number of people full and part time}
#'   \item{aboriginal_and_torres_strait_islander_status}{"Aboriginal and Torres Strait Islander" or  "Non-Indigenous"}
#' }
#' @source \url{https://www.abs.gov.au/statistics/people/education/schools/2020#data-download} (table 42B)
"abs_education_state"
