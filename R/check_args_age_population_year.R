check_args_age_population_year <- function(data,
                                           country_col = NULL,
                                           country = NULL,
                                           age_col,
                                           year_col = NULL,
                                           year = NULL) {
  
  age_population_year_df <- separate_age_group(data, {{age_col}})
  
  if (!is.null(year)) {
    age_population_year_df <- age_population_year_df %>%
      dplyr::filter({{ year_col }} == {{ year }})
  }
  
  if (!is.null(country)) {
    age_population_country_df <- age_population_year_df %>%
      dplyr::filter({{ country_col }} == {{ country }})
    
    return(age_population_country_df)
    
  }
  else
    return(age_population_year_df)
}
