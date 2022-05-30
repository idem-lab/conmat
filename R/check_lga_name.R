#' @title Check LGA name in Australia
#' @param lga_name character of length 1
#' @return errors if lga name not in ABS data
#' @export
check_lga_name <- function(lga_name,multiple_lga=FALSE) {
  lga_match <- dplyr::filter(abs_pop_age_lga_2020,
                             lga %in% lga_name)
  
  does_lga_match <- nrow(lga_match) > 1
  
  if (!does_lga_match) {
    rlang::abort(
      message = c(
        "The LGA name provided does not match LGAs in Australia",
        x = glue::glue("The lga name '{lga_name}' did not match (it probabley needs '{lga_name} (C)' or similar"),
        i = "See `abs_lga_lookup` for a list of all LGAs"
      )
    )
    
  }
  
  if (does_lga_match) {
    unique_lga_names <- abs_pop_age_lga_2020 %>%
      dplyr::filter(lga %in% lga_name) %>%
      dplyr::pull(lga) %>%
      unique()
    
    more_than_one_lga <- length(unique_lga_names) > 1
    
    if (more_than_one_lga & multiple_lga == FALSE) {
      rlang::abort(
        message = c(
          "The LGA name provided matches multiple LGAs",
          i = "Specify the exact LGA name or set multiple_lga as `TRUE`. See `abs_lga_lookup` for a list of all LGAs",
          x = glue::glue("The lga name '{lga_name}' matched multiple LGAs:"),
          glue::glue("{unique_lga_names}")
                         )
        )

    } # end if there is more than one matching LGA
    
  } # end if LGA matches
  
} # end function