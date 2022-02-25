#' @title Return cleaned population data with lower and upper limits of age
#' @param data dataset
#' @param age_col column name for age
#' @param country_col column name for country
#' @param country country name
#' @param year_col column name for year
#' @param year year
#' @return dataset of columns
#' @export
#' @examples
#' \dontrun{ 
#' age_population(
#'   data = data,
#'   country_col = country,
#'   country = "Australia",
#'   age_col = age,
#'   year_col = year,
#'   year = 2015
#' )
#' age_population(
#'   data = data,
#'   country_col = country,
#'   country = "Australia",
#'   age_col = age
#' )
#'   age_population(
#'   data = data,
#'   age_col = age,
#'   year_col = year,
#'   year = 2009
#' )
#' 
#' }

age_population <- function(data,
           country_col = NULL,
           country = NULL,
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
      
      age_population_df <- check_args_age_population_year(
        data = data,
        country_col = {{ country_col }},
        country = {{ country }},
        age_col = age_group,
        year_col = {{ year_col }},
        year = {{ year }}
      )
      
      return(age_population_df)
    } else {
      age_population_df <- check_args_age_population_year(
        data = data,
        country_col = {{ country_col }},
        country = {{ country }},
        age_col = {{ age_col}},
        year_col = {{ year_col}},
        year = {{ year }}
      )

      return(age_population_df)
    }
}
