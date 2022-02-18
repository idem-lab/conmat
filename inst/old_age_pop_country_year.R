
#' @title Return cleaned country specific population data with lower and upper limits of age
#' @param data dataset
#' @param country_col column name for country
#' @param country country name
#' @param age_col column name for age
#' @param year_col column name for year
#' @param year year
#' @return dataset of columns
#' @export
#' @examples
#' age_population_year_country(
#'   data = worldwide_data,
#'   country_col = country,
#'   country = "Australia",
#'   age_col = age,
#'   year_col = year,
#'   year = 2015
#' )
age_population_year_country <- function(data, country_col, country, age_col, year_col, year) {
  cleaned_df <- age_population_year(data, {{ age_col }}, {{ year_col }}, {{ year }})
  return(cleaned_df %>%
           dplyr::filter({{ country_col }} == {{ country }}))
}