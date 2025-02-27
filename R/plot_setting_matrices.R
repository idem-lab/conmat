#' Visualise predicted contact matrix for each setting
#'
#' This is an extension of [plot_matrix()], which visualises the contact
#'   matrix for each setting. It uses `patchwork` to combine all the matrices
#'   together
#'
#' @param matrices A list of square matrices, with row and column names
#'   indicating the age groups.
#' @param title Title to give to plot setting matrices. Default value is:
#'   "Setting-specific synthetic contact matrices (all polymod data)'"
#' @return ggplot visualisation of contact rates for each setting
#' @examples
#' \dontrun{
#'
#' set.seed(2021 - 09 - 24)
#' polymod_contact_data <- get_polymod_setting_data()
#' polymod_survey_data <- get_polymod_population()
#'
#' setting_models <- fit_setting_contacts(
#'   contact_data_list = polymod_contact_data,
#'   population = polymod_survey_data
#' )
#'
#' fairfield <- abs_age_lga("Fairfield (C)")
#'
#' fairfield
#'
#' synthetic_settings_5y_fairfield <- predict_setting_contacts(
#'   population = fairfield,
#'   contact_model = setting_models,
#'   age_breaks = c(seq(0, 85, by = 5), Inf)
#' )
#'
#' plot_setting_matrix(synthetic_settings_5y_fairfield)
#' }
#' @noRd
#' @keywords internal
plot_setting_matrices <- function(
  matrices,
  title = "Setting-specific synthetic contact matrices"
) {
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
