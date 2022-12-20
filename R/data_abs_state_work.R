#' State wise ABS work population data on different ages for year 2016
#'
#' A dataset containing Australian Bureau of Statistics labour force population
#'   data by state for 2016. The data sourced from 2016 Census - Employment,
#'   Income and Education through TableBuilder have been randomly adjusted by
#'   the ABS to avoid the release of confidential data.
#'
#' @format A data frame with 1044 rows and 6 variables:
#' \describe{
#'   \item{year}{2016, as data is from 2016 Census of Population and Housing.}
#'   \item{state}{String. Abbreviated name of state or territory, e.g., 'NSW',
#'     'VIC', 'QLD' and so on.}
#'   \item{age}{Ages from 0 to 115.}
#'   \item{employed_population}{Number of people employed including people
#'     with full-time, part-time employment status.}
#'   \item{total_population}{Total population belonging to the age.}
#'   \item{proportion}{The ratio of employed population and total population
#'      belonging to the age i.e, employed_population/ total_population}
#' }
#' @source {Census of Population and Housing, 2016, TableBuilder}
"data_abs_state_work"
