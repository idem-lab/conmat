#' Plot setting matrices using ggplot2
#'
#' @param object  A matrix or a list of square matrices, with row and column names
#'   indicating the age groups.
#' @param ...	 Other arguments passed on
#' @param title Title to give to plot setting matrices. Default title for plotting a single contact matrix is "Contact Matrices" and for
#' setting wise contact matrix it is "Setting-specific synthetic contact matrices".
#' @return a ggplot visualisation of contact rates
#' @importFrom ggplot2 autoplot
#' @name autoplot-conmat
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   polymod_contact_data <- get_polymod_setting_data()
#'   polymod_survey_data <- get_polymod_population()
#'
#'   setting_models <- fit_setting_contacts(
#'     contact_data_list = polymod_contact_data,
#'     population = polymod_survey_data
#'   )
#'
#'   fairfield_age_pop <- abs_age_lga("Fairfield (C)")
#'
#'   fairfield_hh_size <-
#'     get_per_capita_household_size(lga = "Fairfield (C)")
#'
#'   synthetic_settings_5y_fairfield_hh <- predict_setting_contacts(
#'     population = fairfield_age_pop,
#'     contact_model = setting_models,
#'     age_breaks = c(seq(0, 85, by = 5), Inf),
#'     per_capita_household_size = fairfield_hh_size
#'   )
#'
#'   # Plotting synthetic contact matrices across all settings
#'
#'   autoplot(
#'     object = synthetic_settings_5y_fairfield_hh,
#'     title = "Setting specific synthetic contact matrices"
#'   )
#'
#'   # Work setting specific synthetic contact matrices
#'   autoplot(
#'     object = synthetic_settings_5y_fairfield_hh$work,
#'     title = "Work"
#'   )
#' }
#' }
#' @export
autoplot.conmat_prediction_matrix <- function(object,
                                              ...,
                                              title = "Contact Matrices") {
  plot_matrix(object) +
    ggplot2::ggtitle(title)
}

#' @rdname autoplot-conmat
#' @export
autoplot.conmat_setting_prediction_matrix <- function(object,
                                                      ...,
                                                      title = "Setting-specific synthetic contact matrices") {
  plot_setting_matrices(object,
    title = title
  )
}
