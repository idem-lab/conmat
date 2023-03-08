new_setting_prediction_matrix <- function(list_matrix,
                                          age_breaks = NULL) {
  structure(
    list_matrix,
    age_breaks = age_breaks,
    class = c("conmat_setting_prediction_matrix", class(list_matrix))
  )
}

#' Create a setting prediction matrix
#'
#' Helper function to create your own setting prediction matrix, which you
#'   may want to use in `generate_ngm`, or `autoplot`. This class is the
#'   output of functions like `extrapolate_polymod`, and
#'   `predict_setting_contacts`. We recommend using this function is only for
#'   advanced users, who are creating their own setting prediction matrix.
#'
#' @param ... list of matrices
#' @param age_breaks age breaks - numeric
#'
#' @return setting prediction matrix
#'
#' @examples
#'
#' age_breaks_0_80_plus <- c(seq(0, 80, by = 10), Inf)
#' one_by_nine <- matrix(1, nrow = 9, ncol = 9)
#'
#' x_example <- setting_prediction_matrix(
#'   home = one_by_nine,
#'   work = one_by_nine,
#'   age_breaks = age_breaks_0_80_plus
#' )
#'
#' x_example <- setting_prediction_matrix(
#'   one_by_nine,
#'   one_by_nine,
#'   age_breaks = age_breaks_0_80_plus
#' )
#'
#' x_example
#'
#' @export
setting_prediction_matrix <- function(...,
                                      age_breaks) {
  list_matrix <- prepare_list_matrix(...)

  setting_pred_matrix <- set_age_breaks_matrices(
    list_matrix,
    age_breaks
  )

  # add add setting only if it doesn't exist
  setting_pred_matrix <- add_all_setting(setting_pred_matrix)

  new_setting_prediction_matrix(
    list_matrix = setting_pred_matrix,
    age_breaks = age_breaks
  )
}

#' Coerce object to a setting prediction matrix
#'
#' This will also calculate an `all` matrix, if `all` is not specified.  This
#'   is the sum of all other matrices.
#'
#' @param list_matrix list of matrices
#' @param age_breaks numeric vector of ages
#' @param ... extra arguments (currently not used)
#'
#' @return object of class setting prediction matrix
#'
#' @examples
#'
#' age_breaks_0_80_plus <- c(seq(0, 80, by = 10), Inf)
#' one_by_nine <- matrix(1, nrow = 9, ncol = 9)
#'
#' mat_list <- list(
#'   home = one_by_nine,
#'   work = one_by_nine
#' )
#'
#' mat_list
#'
#' mat_set <- as_setting_prediction_matrix(
#'   mat_list,
#'   age_breaks = age_breaks_0_80_plus
#' )
#'
#' mat_set
#'
#' @export
as_setting_prediction_matrix <- function(list_matrix,
                                         age_breaks,
                                         ...) {
  UseMethod("as_setting_prediction_matrix")
}

#' @export
as_setting_prediction_matrix.default <- function(list_matrix,
                                                 age_breaks,
                                                 ...) {
  cli::cli_abort(
    "{.code as_setting_prediction_matrix} method not implemented for {.cls \\
    {class(list_matrix)}}"
  )
}

#' @export
as_setting_prediction_matrix.conmat_setting_prediction_matrix <- function(list_matrix,
                                                                          age_breaks,
                                                                          ...) {
  cli::cli_warn(
    "{.code as_setting_prediction_matrix} not used as this object is alreadt of
    a {.cls conmat_setting_prediction_matrix} method not implemented for \\
    {.cls {class(list_matrix)}}."
  )
}

#' @export
as_setting_prediction_matrix.list <- function(list_matrix,
                                              age_breaks,
                                              ...) {
  check_if_all_matrix(list_matrix)
  # do something if list_matrix doesn't have any names
  list_matrix <- repair_list_matrix_names(list_matrix)

  setting_pred_matrix <- set_age_breaks_matrices(
    list_matrix,
    age_breaks
  )

  # add add setting only if it doesn't exist
  setting_pred_matrix <- add_all_setting(setting_pred_matrix)

  new_setting_prediction_matrix(
    list_matrix = setting_pred_matrix,
    age_breaks = age_breaks
  )
}
