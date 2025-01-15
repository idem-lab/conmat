#' @title Convert dataframe of predicted contacts into matrix
#'
#' @description Helper function to convert predictions of contact rates in data
#'   frames to matrix format with the survey participant age groups as columns
#'   and contact age groups as rows.
#'
#' @param contact_predictions data frame with columns `age_group_from`,
#'   `age_group_to`, and `contacts`.
#' @param ... extra arguments
#'
#' @return Square matrix with the unique age groups from `age_group_from/to`
#'   in the rows and columns and `contacts` as the values.
#'
#' @examples
#' fairfield <- abs_age_lga("Fairfield (C)")
#'
#' # We can convert the predictions into a matrix
#'
#' fairfield_school_contacts <- predict_contacts(
#'   model = polymod_setting_models$school,
#'   population = fairfield,
#'   age_breaks = c(0, 5, 10, 15, Inf)
#' )
#'
#' fairfield_school_contacts
#'
#' # convert them back to a matrix
#' predictions_to_matrix(fairfield_school_contacts)
#'
#' @export
predictions_to_matrix <- function(contact_predictions, ...) {
  UseMethod("predictions_to_matrix")
}

#' @export
predictions_to_matrix.predicted_contacts <- function(contact_predictions, ...) {
  prediction_matrix <- contact_predictions %>%
    tidyr::pivot_wider(
      names_from = age_group_from,
      values_from = contacts
    ) %>%
    tibble::column_to_rownames(
      "age_group_to"
    ) %>%
    as.matrix() %>%
    new_age_matrix(age_breaks = age_breaks(contact_predictions))

  prediction_matrix
}
