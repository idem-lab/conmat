new_prediction_matrix <- function(matrix) {
  class(matrix) <- c("conmat_prediction_matrix", class(matrix))
  matrix
}

new_setting_prediction_matrix <- function(list_matrix) {
  class(list_matrix) <- c(
    "conmat_setting_prediction_matrix",
    class(list_matrix)
  )
  list_matrix
}
