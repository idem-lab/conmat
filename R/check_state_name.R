#' @title Check state name in Australia
#' @param state_name character of length 1
#' @return errors if state name not in ABS data
#' @export
check_state_name <- function(state_name) {
  
  state_match <- stringr::str_detect(
    string = abs_pop_age_lga_2020$state, 
    pattern = state_name
  )
  
  does_state_match <- !any(state_match)
  
  if (does_state_match) {
    
    rlang::abort(
      message = c("The state name provided does not match states in Australia",
                  x = glue::glue("The state name '{state_name}' did not match"),
                  i = "See `abs_lga_lookup` for a list of all states")
    )
    
  }
  
}
