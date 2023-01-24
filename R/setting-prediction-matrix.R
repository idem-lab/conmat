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

  setting_pred_matrix$all <- Reduce("+", setting_pred_matrix)

  new_setting_prediction_matrix(
    list_matrix = setting_pred_matrix,
    age_breaks = group_age_breaks(age_breaks)
  )
}
