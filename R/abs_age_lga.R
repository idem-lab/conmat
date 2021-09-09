#' @title Return abs age population data for a given LGA
#' @param lga lga name - can be a partial match, e.g.,  although the official name might be "Albury (C)", "Albury" is fine. It must also match exactly one LGA. See [check_lga_name()] for more details.
#' @return dataset of columns
#' @export
#' @examples 
#' abs_age_lga("Albury")
abs_age_lga <- function(lga_name) {
  
  # check LGA name
  check_lga_name(lga_name)

  abs_pop_age_lga_2020 %>% 
    dplyr::filter(lga == lga_name) %>% 
    dplyr::select(lga,
           age_group,
           year,
           population) %>% 
    dplyr::mutate(age_group = readr::parse_number(age_group)) %>% 
    dplyr::rename(lower.age.limit = age_group)

}
