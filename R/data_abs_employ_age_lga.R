#' ABS employment by age and LGA for 2016
#'
#' A dataset containing Australian Bureau of Statistics employment data by
#'   state for 2016
#'
#' @format A data frame with 5600 rows and 8 variables:
#' \describe{
#'   \item{year}{year - 2016}
#'   \item{state}{state - short state or territory name}
#'   \item{lga}{local government area name}
#'   \item{age_group}{age groups are as follows: 15-19, 20-24, 25-34, 35-44,
#'   45-54, 55-64, 65-74, 75-84, 85+, total}
#'   \item{total_employed}{total  number of people employed}
#'   \item{total_unemployed}{total number of people unemployed}
#'   \item{total_labour_force}{total number of people in the labour force}
#'   \item{total}{sum of these totals...or thereabouts??}
#' }
#' @note still need to finalise these columns
#' @source ABS.stat \url{https://stat.data.abs.gov.au/Index.aspx?} LABOUR >
#'   Employment and Unemployment > Labour force status >
#'   Census 2016, G43 labour status by age and sex (LGA)
"abs_employ_age_lga"
