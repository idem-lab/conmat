#' Add features required for modelling to the dataset
#'
#' @param contact_data contact data
#' @param ... extra dots
#' @return data frame
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
add_modelling_features <- function(contact_data, ...) {
  contact_data %>%
    add_population_age_to(...) %>%
    add_school_work_participation() %>%
    add_rotated_ages()
}
