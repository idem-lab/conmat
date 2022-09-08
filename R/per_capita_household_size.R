#' @title Get per capita household size with household size distribution
#' 
#' @description Returns the per capita household size for a location given 
#'   its household size distribution. See [get_household_size_distribution()] 
#'   function for retrieving household size distributions for a given place.
#'   
#' @param household_data data set with information on the household size
#'   distribution of specific state or LGA. 
#' @param household_size_col bare variable name of the column depicting the
#'   household size. Default is 'household_size' from
#'   [get_household_size_distribution()].
#' @param n_people_col bare variable name of the column depicting the total
#'   number of people belonging to the respective household size. Default is
#'   'n_people' from [get_household_size_distribution()]. 
#' @return Numeric of length 1 - the per capita household size for a given 
#'   state or LGA.
#' @author Nick Golding
#' @export
#' @examples 
#' demo_data <- get_household_size_distribution(lga = "Fairfield (C)")
#' demo_data
#' per_capita_household_size(household_data=demo_data,
#'                           household_size_col=household_size,
#'                           n_people_col=n_people)
#' 
#' 
per_capita_household_size <- function(household_data,
                                      household_size_col=household_size,
                                      n_people_col=n_people) {
 
  # aggregate and average household sizes
  household_data %>%
    dplyr::group_by(
      {{ household_size_col }},
      .add = TRUE
    ) %>%
    dplyr::summarise(
      n_people = sum({{ n_people_col }}),
      .groups = "drop"
    ) %>%
    dplyr::mutate(
      # as a fraction of the population
      fraction = n_people / sum(n_people)
    ) %>%
    dplyr::summarise(
      per_capita_household_size = sum({{ household_size_col }} * fraction),
      .groups = "drop"
    ) %>%
    dplyr::pull(
      per_capita_household_size
    )
  
}
