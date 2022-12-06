#' @title Return  data on employed population for a given age and state or 
#'   lga of Australia
#' @param state target Australian state name or a vector with multiple state 
#'   names in its abbreviated form, such as "QLD", "NSW", or "TAS"
#' @param lga target Australian local government area (LGA) name, such as 
#'   "Fairfield (C)" or a vector with multiple lga names. See 
#'   [abs_lga_lookup()] for list of lga names.
#' @param age a numeric or numeric vector denoting ages between 0 to 115. 
#'   The default is to return all ages.
#' @return data set with information on the number of employed people belonging 
#'   to a particular age, its total population and the corresponding proportion.
#' @export
#' @examples
#' get_data_abs_age_work(state="NSW")
#' get_data_abs_age_work(state="WA",lga="Albany (C)",age=1:5)
#' get_data_abs_age_work(state=c("QLD","TAS"),age=5)
#' get_data_abs_age_work(lga=c("Albury (C)","Barcoo (S)"),age=39)

get_data_abs_age_work <- function(age=NULL, state=NULL, lga=NULL) {
  # checks only for state 
  if (!is.null(state) & is.null(lga)) {
    
    check_state_name(state,multiple_state=TRUE)
    data_subset <- data_abs_state_work %>%
      dplyr::filter(state %in% {{ state }})
    
  } else{
    # checks for lga 
    if (!is.null(lga)) {
      
      check_lga_name(lga, multiple_lga = TRUE)
      
      # checks if there is a state argument as well
      # if state argument present, it filters for it
      if (!is.null(state))
      {
        data_subset <- data_abs_lga_work %>%
          dplyr::filter(lga %in% {{ lga }} , state %in% {{ state }})
        
        # if empty tibble , error message 
        if (nrow(data_subset) == 0)
        {
          rlang::abort(
            message = c(
              "The LGA name provided does not belong to the state",
              i = "Specify the exact LGA name and the corresponding state \\
              it belongs to. See `abs_lga_lookup` for a list of all LGAs and \\
              the state it belongs to",
              x = glue::glue(
                "The lga name '{lga}' does not belong to the state '{state}'"
              )
            )
          )
        } else{
          # if tibble not empty, do nothing
          data_subset 
        }
      } else {
        # if there is no state argument along with lga
        data_subset <- data_abs_lga_work %>%
          dplyr::filter(lga %in% {{ lga }})
      }
    }
  } # end check for state & lga
  if (!is.null(age))
  {
    data_subset %>%
      dplyr::filter(age %in% {{ age }})
    
  } else {
    data_subset
  }

  }