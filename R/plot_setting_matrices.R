#' Plot setting matrices using ggplot2
#' 
#' @param matrices matrix
#' @param title title to give, Default: 'Setting-specific synthetic contact matrices (all polymod data)'
#' @return ggplot
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @export 
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
