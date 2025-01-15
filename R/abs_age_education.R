#' @title Return  data on educated population for a given age and state or
#'   lga of Australia.
#' @param state target Australian state name or a vector with multiple state
#'   names in its abbreviated form, such as "QLD", "NSW", or "TAS"
#' @param age a numeric or numeric vector denoting ages between 0 to 115. The
#'    default is to return all ages.
#' @return dataset with information on the number of educated people belonging
#'   to a particular age, its total population and the corresponding proportion.
#' @rdname abs-age-education
#' @export
#' @examples
#' abs_age_education_state(state = "VIC")
#' abs_age_education_state(state = "WA", age = 1:5)
#' abs_age_education_state(state = c("QLD", "TAS"), age = 5)
#' abs_age_education_lga(lga = c("Albury (C)", "Barcoo (S)"), age = 10)
#'
abs_age_education_state <- function(state = NULL, age = NULL) {
  check_state_name(state, multiple_state = TRUE)
  data_subset <- data_abs_state_education %>%
    dplyr::filter(state %in% {{ state }})

  if (!is.null(age)) {
    data_subset <- data_subset %>% dplyr::filter(age %in% {{ age }})
  }

  data_subset
}

#' @param lga target Australian local government area (LGA) name, such as
#'   "Fairfield (C)" or a vector with multiple lga names. See
#'   [abs_lga_lookup()] for list of lga names.
#' @name abs-age-education
#' @export
abs_age_education_lga <- function(lga = NULL, age = NULL) {
  check_lga_name(lga, multiple_lga = TRUE)

  data_subset <- data_abs_lga_education %>%
    dplyr::filter(lga %in% {{ lga }})

  if (!is.null(age)) {
    data_subset <- data_subset %>% dplyr::filter(age %in% {{ age }})
  }

  data_subset
}
