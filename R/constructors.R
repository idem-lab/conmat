add_new_class <- function(x, new_class) {
  class(x) <- c(new_class, class(x))
  x
}

new_prediction_matrix <- function(matrix) {
  add_new_class(matrix, "conmat_prediction_matrix")
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