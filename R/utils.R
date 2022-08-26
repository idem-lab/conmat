#' Prepare age population data
#' 
#' Internally used function within [age_population()] to separate age groups 
#'   into its lower & upper limit and then filter the data passed to the desired 
#'   year and location.
#'
#' @param data data.frame
#' @param location_col bare unquoted variable referring to location column
#' @param location location name to filter to. If not specified gives all locations.
#' @param age_col bare unquoted variable referring to age column
#' @param year_col bare unquoted variable referring to year column
#' @param year year to filter to. If not specified, gives all years.
#' 
#' @keywords internal
#'
#' @return data frame with lower.age.limit and upper.age.limit and optionally
#'   filtered down to specific location or year.
clean_age_population_year <- function(data,
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
    return(age_population_year_df) 
    # return the whole data frame or the df with only year filter 
    # if year variable is present
  }
}

#' Separate age groups
#' 
#' An internal function used within [clean_age_population_year()] to
#'   separate age groups in a data set into two variables, `lower.age.limit`, 
#'   and `upper.age.limit`
#'
#' @param data data frame
#' @param age_col bare unquoted column referring to age column
#' @keywords internal
#' @return data frame with two extra columns, `lower.age.limit` and 
#'   `upper.age.limit`
separate_age_group <- function(data, age_col) {
  result <- data %>%
    tibble::as_tibble() %>% 
    tidyr::separate(
      {{ age_col }},
      c("lower.age.limit", "upper.age.limit"),
      "[[:punct:]]",
      extra = "merge"
    ) %>%
    dplyr::mutate(
      across(
        .cols = c(lower.age.limit, upper.age.limit),
        .fns = function(x) readr::parse_number(as.character(x))
      )
    )

  result
}

check_if_only_one_null <- function(x, y){
  x_null <- is.null(x)
  y_null <- is.null(y)
  null_sum <- x_null + y_null
  no_null <- null_sum == 0
  one_null <- null_sum == 1
  both_null <- null_sum == 2
  
  if (no_null){
    return()
  } 
  
  if (both_null){
    return()
  }
  
  if (one_null) {
    msg <- cli::format_error(
      c(
        "Both variables need to be specified, only one is",
        "i" = "{.var x} is {ifelse(is.null(x), 'NULL', x)}",
        "i" = "{.var y} is {ifelse(is.null(y), 'NULL', y)}",
        "You are seeing this error message because you need to specify both \\
        of {.var location_col} & {.var location}, or {.var year_col} & \\
        {.var year} as either NULL or with values"
      )
      
    )
    stop(
      msg,
      call. = FALSE
    )
  }
  
}