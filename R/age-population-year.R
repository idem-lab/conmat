#' @title Get cleaned population data with lower and upper limits of age.
#' 
#' @description This function helps clean up datasets of population data, 
#'   similar to `socialmixr::wpp_age()` or any given dataset with a structure 
#'   that has information on, population, location, age, and year.
#' @param data dataset containing information on population for a given age, 
#'   country, and year
#' @param age_col bare variable name for the column with age information 
#' @param location_col bare variable name for the column with location 
#'   information
#' @param location character vector with location names
#' @param year_col bare variable name for the column with year information
#' @param year numeric vector representing the desired year(s)
#' @return tidy dataset with information on population of different age bands
#' @export
#' @examples
#' world_data <- socialmixr::wpp_age()
#' # Tidy data for multiple locations across different years
#'age_population(
#'data = world_data,
#'location_col = country,
#'location = c("Asia","Afghanistan"),
#'age_col = lower.age.limit,
#'year_col = year,
#'year = c(2010:2020)
#')
#'
#'# Tidy data for a given location irrespective of year
#'age_population(
#'  data = world_data,
#' location_col = country,
#'  location = "Afghanistan",
#'  age_col = lower.age.limit
#' )
#' 
#' # Tidy datasets with age groups
#'population_age_groups <- abs_pop_age_lga_2020
#' age_population(
#' data = population_age_groups,
#' age_col = age_group,
#' year_col = year,
#' year = 2020
#' )
#' 
#' # Tidy datasets with numeric age
#' population_numeric_age <- abs_age_state("WA")
#' age_population(
#' data = population_numeric_age,
#' age_col = lower.age.limit,
#' year_col = year,
#' year = 2020
#' )
#' 
age_population <- function(data,
                           location_col = NULL,
                           location = NULL,
                           age_col,
                           year_col = NULL,
                           year = NULL) {
  
  # checks the data type of age col and puts age into buckets if its numeric 
  # which gets separated later as lower and upper limits
  
  age_var <- dplyr::pull(data, {{ age_col }})
  
  
  if (is.numeric(age_var)) {
    label <- c(paste(seq(0, max(age_var), by = 5),
                     seq(0 + 5 - 1, max(age_var)+5 - 1, by = 5),
                     sep = "-"))
    
    data <- data %>%
      dplyr::mutate(
        age_group = cut({{ age_col }},
                        breaks = c(seq(0, max(age_var), by = 5), Inf),
                        labels = label, right = FALSE)
      )
    
    age_population_df <- clean_age_population_year(
      data = data,
      location_col = {{ location_col }},
      location = {{ location }},
      age_col = age_group,
      year_col = {{ year_col }},
      year = {{ year }}
    )
    
    return(age_population_df)
  } else {
    age_population_df <- clean_age_population_year(
      data = data,
      location_col = {{ location_col }},
      location = {{ location }},
      age_col = {{ age_col}},
      year_col = {{ year_col}},
      year = {{ year }}
    )
    
    return(age_population_df)
  }
}