add_new_class <- function(x, new_class) {
  class(x) <- c(new_class, class(x))
  x
}

#' Build new age matrix
#' 
#' A matrix that knows about its age breaks - which are by default provided as
#'   its rownames. Mostly intended for internal use.
#'
#' @param matrix numeric matrix
#' @param age_breaks character vector of age breaks, by default the rownames.
#'
#' @return matrix with age breaks attribute
#'
#' @examples
#' age_break_names <- c("[0,5)", "[5,10)", "[10, 15)")
#' age_mat <- matrix(
#'   runif(9),
#'   nrow = 3,
#'   ncol = 3,
#'   dimnames = list(
#'     age_break_names,
#'     age_break_names
#'   )
#' )
#' 
#' new_age_matrix(age_mat)
#' new_age_matrix(age_mat,
#'                age_breaks = age_break_names)
#' 
#' @export
new_age_matrix <- function(matrix, age_breaks = rownames(matrix)) {
  stopifnot(is.character(age_breaks))
  structure(
    matrix,
    age_breaks = age_breaks,
    class = c("conmat_age_matrix", class(matrix))
  )
}

#' Extract age break attribute information
#'
#' @param matrix a `conmat_age_matrix` matrix
#'
#' @return age breaks character vector
#' @examples
#' #' age_break_names <- c("[0,5)", "[5,10)", "[10, 15)")
#' age_mat <- matrix(
#'   runif(9),
#'   nrow = 3,
#'   ncol = 3,
#'   dimnames = list(
#'     age_break_names,
#'     age_break_names
#'   )
#' )
#' 
#' age_mat <- new_age_matrix(age_mat)
#' 
#' age_breaks(age_mat)
#' @export
age_breaks <- function(matrix){
  UseMethod("age_breaks")
}

#' @describeIn age_breaks Get age break information
age_breaks.conmat_age_matrix <- function(matrix){
  attr(matrix, "age_breaks")
}

new_setting_prediction_matrix <- function(list_matrix) {
  add_new_class(list_matrix, "conmat_setting_prediction_matrix")
}

new_setting_data <- function(list_df) {
  add_new_class(list_df, "setting_data")
}

new_ngm_setting_matrix <- function(list_matrix) {
  add_new_class(list_matrix, "ngm_setting_matrix")
}

new_setting_contact_model <- function(list_model) {
  add_new_class(list_model, "setting_contact_model")
}

new_setting_vaccination_matrix <- function(list_matrix) {
  add_new_class(list_matrix, "setting_vaccination_matrix")
}

new_transmission_probability_matrix <- function(list_matrix) {
  add_new_class(list_matrix, "transmission_probability_matrix")
}
