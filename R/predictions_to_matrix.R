#' Predict contacts to matrix
#' @param contact_predictions PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
predictions_to_matrix <- function(contact_predictions) {
  contact_predictions %>%
    tidyr::pivot_wider(
      names_from = age_group_from,
      values_from = contacts
    ) %>%
    tibble::column_to_rownames(
      "age_group_to"
    ) %>%
    as.matrix()
}
