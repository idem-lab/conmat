#' @title Return Australian Bureau of Statistics (ABS) age population data for a
#'   given Local Government Area (LGA) or state
#' @param lga_name lga name - can be a partial match, e.g.,  although the official name might be "Albury (C)", "Albury" is fine. 
#' @return dataset of: `lga` (or `state`), `lower.age.limit`, `year`,
#'   and `population`.
#' @name abs_age_data
#' @export
#' @examples
#' abs_age_lga(c("Albury (C)","Fairfield (C)"))
#' abs_age_state(c("NSW","VIC"))
abs_age_lga <- function(lga_name) {
  check_lga_name(lga_name, multiple_lga = TRUE)

  abs_population <- abs_pop_age_lga_2020 %>%
    dplyr::filter(lga %in% lga_name) %>%
    dplyr::select(
      lga,
      age_group,
      year,
      population
    ) %>%
    dplyr::mutate(age_group = readr::parse_number(as.character(age_group))) %>%
    dplyr::rename(lower.age.limit = age_group)

  conmat_population(
    data = abs_population,
    age = lower.age.limit,
    population = population
  )
}

#' @param state_name shortened state name
#' @rdname abs_age_data
#' @export
abs_age_state <- function(state_name) {
  
  check_state_name(state_name,multiple_state = TRUE)

  abs_population <- abs_pop_age_lga_2020 %>%
    dplyr::filter(state %in% state_name) %>%
    dplyr::select(
      state,
      age_group,
      year,
      population
    ) %>%
    dplyr::mutate(age_group = readr::parse_number(as.character(age_group))) %>%
    dplyr::rename(lower.age.limit = age_group) %>%
    dplyr::group_by(year, state, lower.age.limit) %>%
    dplyr::summarise(population = sum(population))
  
  conmat_population(
    data = abs_population,
    age = lower.age.limit,
    population = population
  )
}
