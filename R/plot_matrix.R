#' Use ggplot to plot a matrix in the output format
#' @param matrix matrix
#' @return a ggplot object
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
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
