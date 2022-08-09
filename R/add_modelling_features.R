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
#' @note internal
#' @export
add_modelling_features <- function(contact_data, ...) {
  contact_data %>%
    # Adds interpolated age population - specifically, `pop_age_to`
    add_population_age_to(...) %>%
    # Adds school and work offset
    add_symmetrical_features() %>%
    add_school_work_participation() %>%
    # adds columns 
    # `log_contactable_population_school`, and ` log_contactable_population`
    add_offset()
}
