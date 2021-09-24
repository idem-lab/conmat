#' Plot setting matrices using ggplot2
#' 
#' @param matrices matrix
#' @param title Title to give to plot setting matrices. Default value is: Setting-specific synthetic contact matrices (all polymod data)'
#' @return a ggplot
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
plot_setting_matrices <- function(matrices,
                                  title = "Setting-specific synthetic contact matrices") {
  
  plot_home <- plot_matrix(matrices$home) + ggplot2::ggtitle("home")
  plot_school <- plot_matrix(matrices$school) + ggplot2::ggtitle("school") 
  plot_work <- plot_matrix(matrices$work) + ggplot2::ggtitle("work")
  plot_other <- plot_matrix(matrices$other) + ggplot2::ggtitle("other")
    
  patchwork::wrap_plots(
    plot_home,
    plot_school,
    plot_work,
    plot_other
  ) +
    patchwork::plot_layout(ncol = 2) +
    patchwork::plot_annotation(
      title = title
    )
}
