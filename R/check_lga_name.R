#' @title Check LGA name in Australia
#' @param lga_name character of length 1
#' @return errors if lga name not in ABS data
#' @export
check_lga_name <- function(lga_name) {

  lga_match <- stringr::str_detect(
    string = abs_pop_age_lga_2020$lga, 
    pattern = lga_name
  )
  
  does_lga_match <- !any(lga_match)
  
  if (does_lga_match) {
    
    rlang::abort(
      message = c("The LGA name provided does not match LGAs in Australia",
                  x = glue::glue("The lga name '{lga_name}' did not match"),
                  i = "See `abs_lga_lookup` for a list of all LGAs")
    )
    
  }

}
