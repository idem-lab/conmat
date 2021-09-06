# apply a 45 degree rotation to age contact pairs, to model trends along the
# diagonal, and perpendicularly across the diagonal
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param contact_data PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[dplyr]{mutate}}
#' @rdname add_rotated_ages
#' @export 
#' @importFrom dplyr mutate
add_rotated_ages <- function(contact_data) {
  theta <- pi / 4
  contact_data %>%
    dplyr::mutate(
      along_diagonal = age_from * cos(theta) + age_to * cos(theta),
      across_diagonal = age_from * cos(theta) - age_to * sin(theta)
    )
}
