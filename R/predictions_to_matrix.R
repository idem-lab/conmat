#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param contact_predictions PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[tidyr]{pivot_wider}}
#'  \code{\link[tibble]{rownames}}
#' @rdname predictions_to_matrix
#' @export 
#' @importFrom tidyr pivot_wider
#' @importFrom tibble column_to_rownames
predictions_to_matrix <- function(contact_predictions) {
  contact_predictions %>%
    tidyr::pivot_wider(
      names_from = age_group_to,
      values_from = contacts
    ) %>%
    tibble::column_to_rownames(
      "age_group_from"
    ) %>%
    as.matrix()
}
