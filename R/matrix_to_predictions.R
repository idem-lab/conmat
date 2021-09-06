#' Convert a contact matrix as output by these functions (or socialmixr) into 
#' a long-form tibble
#' 
#' @param contact_matrix PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @export 
matrix_to_predictions <- function(contact_matrix) {
  contact_matrix %>%
    tibble::as_tibble(
      rownames = "age_group_from"
    ) %>%
    tidyr::pivot_longer(
      cols = -c(age_group_from),
      names_to = "age_group_to",
      values_to = "contacts"
    ) %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("age_group"),
        ~factor(.x, levels = unique(.x))
      )
    )
}
