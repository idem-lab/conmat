#' LGA wise ABS work population data on different ages for year 2016
#'
#' A dataset containing Australian Bureau of Statistics labour force population data by
#'   lga for 2016. The data sourced from 2016 Census - Employment, Income and Education through TableBuilder have been randomly adjusted by the ABS to avoid the release of confidential data.
#'   As a result of this, there are some cases where the estimated number of people being employed is higher than the population of those people. 
#'   Such cases have been flagged under the `anomaly_flag` variable.
#'
#' @format A data frame with 64,264 rows and 8 variables:
#' \describe{
#'   \item{year}{a number denoting the year as 2016. Year is denoted 2016 since the data is based on 2016 Census of Population and Housing.}
#'   \item{state}{a string denoting the abbreviated name of state or territory name such as 'NSW', 'VIC', 'QLD' and so on.}
#'   \item{lga}{a string denoting the official name of Local Government Area. For example, 'Albury (C).'}
#'   \item{age}{a number denoting ages from 0 to 115.}
#'   \item{employed_population}{a number denoting number of people employed including people with full-time, part-time employment status.}
#'   \item{total_population}{a number depicting the total population belonging to the age.}
#'   \item{proportion}{a number denoting the measure of the ratio of employed population and total population belonging to the age i.e, employed_population/ total_population}
#'   \item{anomaly_flag}{a logical variable with values TRUE and FALSE that flags the abnormal observations in the data such as total population lesser than employed_population as TRUE.}
#' }
#' @source {Census of Population and Housing, 2016, TableBuilder}
"data_abs_lga_work"