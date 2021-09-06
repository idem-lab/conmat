#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param matrices PARAM_DESCRIPTION
#' @param title PARAM_DESCRIPTION, Default: 'Setting-specific synthetic contact matrices (all polymod data)'
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[ggplot2]{labs}}
#'  \code{\link[patchwork]{plot_layout}},\code{\link[patchwork]{plot_annotation}}
#' @rdname plot_setting_matrices
#' @export 
#' @importFrom ggplot2 ggtitle
#' @importFrom patchwork plot_layout plot_annotation
plot_setting_matrices <- function(
  matrices,
  title = "Setting-specific synthetic contact matrices (all polymod data)"
) {
  plot_matrix(matrices$home) +
    ggplot2::ggtitle("home") +
    plot_matrix(matrices$school) +
    ggplot2::ggtitle("school") +
    plot_matrix(matrices$work) +
    ggplot2::ggtitle("work") +
    plot_matrix(matrices$other) +
    ggplot2::ggtitle("other") +
    patchwork::plot_layout(ncol = 2) +
    patchwork::plot_annotation(
      title = title
    )
}
