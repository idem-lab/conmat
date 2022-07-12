
check_args_age_population_year <- function(data,
                                           location_col = NULL,
                                           location = NULL,
                                           age_col,
                                           year_col = NULL,
                                           year = NULL) {
  
  # separate age group into "lower.age.limit" & "upper.age.limit" 
  age_population_year_df <- separate_age_group(data, {{ age_col }})
  
  # filter year only
  
  if (!is.null(year)) {
    age_population_year_df <- age_population_year_df %>%
      dplyr::filter({{ year_col }} %in% {{ year }})
  }
  
 # filter year & location
  if (!is.null(location)) {
    age_population_location_df <- age_population_year_df %>%
      dplyr::filter({{ location_col }} %in% {{ location }})
    
    return(age_population_location_df)
  } else {
    return(age_population_year_df) #return the whole data frame or the df with only year filter 
                                   #if year variable is present
  }
}