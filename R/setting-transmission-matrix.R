new_transmission_probability_matrix <- function(list_matrix,
                                                age_breaks = NULL) {
  structure(
    list_matrix,
    age_breaks = age_breaks,
    class = c("transmission_probability_matrix", class(list_matrix))
  )
}

#' Create a setting transmission matrix
#'
#' Helper function to create your own setting transmission matrix, which you
#'   may want to use in ... or `autoplot`. This class is the
#'   output of functions like `...`, and ... . We recommend using this
#'   function is only for advanced users, who are creating their own
#'   transmission probability matrix.
#'
#' @param ... list of matrices
#' @param age_breaks age breaks - numeric
#'
#' @return transmission probability matrix
#'
#' @examples
#'
#' age_breaks_0_80_plus <- c(seq(0, 80, by = 10), Inf)
#' one_05 <- matrix(0.05, nrow = 9, ncol = 9)
#'
#' x_example <- transmission_probability_matrix(
#'   home = one_05,
#'   work = one_05,
#'   age_breaks = age_breaks_0_80_plus
#' )
#'
#' x_example <- transmission_probability_matrix(
#'   one_05,
#'   one_05,
#'   age_breaks = age_breaks_0_80_plus
#' )
#'
#' x_example
#'
#' @export
transmission_probability_matrix <- function(...,
                                            age_breaks) {
  list_matrix <- prepare_list_matrix(...)

  setting_transmission_mat <- set_age_breaks_matrices(
    list_matrix,
    age_breaks
  )

  new_transmission_probability_matrix(
    list_matrix = setting_transmission_mat,
    age_breaks = age_breaks
  )
}
