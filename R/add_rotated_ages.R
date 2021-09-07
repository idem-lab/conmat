#' apply a 45 degree rotation to age contact pairs
#'
#' apply a 45 degree rotation to age contact pairs, to model trends along
#' the diagonal, and perpendicularly across the diagonal.
#'
#' @param contact_data contact data
#' @return data set with rotated age contact paris
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
add_rotated_ages <- function(contact_data) {
  theta <- pi / 4
  contact_data %>%
    dplyr::mutate(
      along_diagonal = age_from * cos(theta) + age_to * cos(theta),
      across_diagonal = age_from * cos(theta) - age_to * sin(theta)
    )
}
