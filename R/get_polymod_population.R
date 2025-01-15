#' @title Return the polymod-average population age distribution in 5y
#'
#' @description returns the polymod-average population age distribution in
#'   5y increments (weight country population distributions by number of
#'   participants). Note that we don't want to weight by survey age
#'   distributions for this, since the total number of *participants*
#'   represents the sampling. It uses the participant data from the polymod
#'   survey as well as the age specific population data from `socialmixr`
#'   R package to return the age specific average population of different,
#'   countries weighted by the number of participants from those countries who
#'   participated in the polymod survey.
#'
#' @param countries countries to extract data from. Default is to get: Belgium,
#'   Finland, Germany, Italy, Luxembourg, Netherlands, Poland, and
#'   United Kingdom.
#' @return A `conmat_population` data frame with two columns: `lower.age.limit`
#'   and `population`
#' @examples
#' get_polymod_population()
#' get_polymod_population("Belgium")
#' get_polymod_population("United Kingdom")
#' get_polymod_population("Italy")
#' @export
get_polymod_population <- function(countries = c(
                                     "Belgium",
                                     "Finland",
                                     "Germany",
                                     "Italy",
                                     "Luxembourg",
                                     "Netherlands",
                                     "Poland",
                                     "United Kingdom"
                                   )) {
  socialmixr::polymod$participants %>%
    dplyr::filter(
      !is.na(year),
      country %in% countries,
      # there were two luxembourgs otherwise - one in 2005!
      year == 2006
    ) %>%
    dplyr::group_by(
      country,
      year
    ) %>%
    dplyr::summarise(
      participants = dplyr::n(),
      .groups = "drop"
    ) %>%
    dplyr::left_join(
      socialmixr::wpp_age() %>% dplyr::filter(year == 2005) %>% dplyr::select(country, lower.age.limit, population),
      by = c("country")
    ) %>%
    dplyr::filter(
      !is.na(lower.age.limit)
    ) %>%
    dplyr::group_by(
      lower.age.limit
    ) %>%
    dplyr::summarise(
      population = stats::weighted.mean(population, participants)
    ) %>%
    conmat_population(
      age = lower.age.limit,
      population = population
    )
}
