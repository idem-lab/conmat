#' ABS employment by age and lga for 2016
#'
#' A dataset containing Australian Bureau of Statistics employment data by
#'   state for 206
#'
#' @format A data frame with 4317 rows and 13 variables:
#' \describe{
#'   \item{year}{year - 2-16}
#'   \item{state}{state - long state or territory name}
#'   \item{lga}{local government area name}
#'   \item{age_group}{age groups are as follows: 15-19, 20-24, 25-34, 35-44, 45-54, 55-64, 
#'     65-74, 75-84, 85+, total}
#'   \item{total_employed}{total  number of people employed}
#'   \item{total_unemploted}{total number of people unemployed}
#'   \item{total_labour_force}{total number of people in the labour force}
#'   \item{total}{sum of these totals...or thereabouts??}
#' }
#' @note still need to finalise these columns
#' @source ABS.stat \url{https://stat.data.abs.gov.au/Index.aspx?} LABOUR >
#'   Employment and Unemployment > Labour force status >
#'   Census 2016, G43 labour status by age and sex (LGA)
"abs_employ_age_lga"
