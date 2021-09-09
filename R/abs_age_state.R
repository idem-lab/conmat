#' @title Return abs age population data for a given state of Australia
#' @param state_name shortened state name
#' @return dataset of columns
#' @export
#' @examples 
#' abs_age_state("NSW")
abs_age_state <- function(state_name) {
  
  # check LGA name
  check_state_name(state_name)
  
  abs_pop_age_lga_2020 %>% 
    dplyr::filter(
      stringr::str_detect(
        string = state, 
        pattern = state_name
      )
    ) %>% 
    dplyr::select(state,
                  age_group,
                  year,
                  population) %>% 
    dplyr::mutate(age_group = readr::parse_number(age_group)) %>% 
    dplyr::rename(lower.age.limit = age_group) %>% 
    dplyr::group_by(year, state, lower.age.limit) %>% 
    dplyr::summarise(population = sum(population))
  
}
