# use ggplot to plot a matrix in the output format
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param matrix PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[ggplot2]{ggplot}},\code{\link[ggplot2]{aes}},\code{\link[ggplot2]{geom_raster}},\code{\link[ggplot2]{coord_fixed}},\code{\link[ggplot2]{scale_colour_brewer}},\code{\link[ggplot2]{ggtheme}},\code{\link[ggplot2]{theme}},\code{\link[ggplot2]{margin}}
#' @rdname plot_matrix
#' @export 
#' @importFrom ggplot2 ggplot aes geom_tile coord_fixed scale_fill_distiller theme_minimal theme element_text
plot_matrix <- function(matrix) {
  
  matrix %>%
    matrix_to_predictions() %>%
    ggplot2::ggplot(
      ggplot2::aes(
        x = age_group_from,
        y = age_group_to,
        fill = contacts
      )
    ) +
    ggplot2::geom_tile() +
    ggplot2::coord_fixed() +
    ggplot2::scale_fill_distiller(
      direction = 1,
      trans = "sqrt"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text = ggplot2::element_text(
        size = 6,
        angle = 45,
        hjust = 1
      )
    )
}
