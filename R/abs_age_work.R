#' @title Return  data on employed population for a given age and state or
#'   lga of Australia
#' @param lga target Australian local government area (LGA) name, such as
#'   "Fairfield (C)" or a vector with multiple lga names. See
#'   [abs_lga_lookup()] for list of lga names.
#' @param age a numeric or numeric vector denoting ages between 0 to 115.
#'   The default is to return all ages.
#' @return data set with information on the number of employed people belonging
#'   to a particular age, its total population and the corresponding proportion.
#' @rdname abs-age-work
#' @export
#' @examples
#' abs_age_work_state(state = "NSW")
#' abs_age_work_state(state = c("QLD", "TAS"), age = 5)
#' abs_age_work_lga(lga = "Albany (C)", age = 1:5)
#' abs_age_work_lga(lga = c("Albury (C)", "Barcoo (S)"), age = 39)
#'
abs_age_work_lga <- function(lga = NULL, age = NULL) {
  check_lga_name(lga, multiple_lga = TRUE)
  data_subset <- data_abs_lga_work %>% dplyr::filter(lga %in% {{ lga }})

  if (!is.null(age)) {
    data_subset <- data_subset %>% dplyr::filter(age %in% {{ age }})
  }

  data_subset
}

#' @param state target Australian state name or a vector with multiple state
#'   names in its abbreviated form, such as "QLD", "NSW", or "TAS"
#' @name abs-age-work
#' @export
abs_age_work_state <- function(state = NULL, age = NULL) {
  check_state_name(state, multiple_state = TRUE)
  data_subset <- data_abs_state_work %>% dplyr::filter(state %in% {{ state }})

  if (!is.null(age)) {
    data_subset <- data_subset %>% dplyr::filter(age %in% {{ age }})
  }

  data_subset
}
