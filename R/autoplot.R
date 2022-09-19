#' Plot setting matrices using ggplot2
#' 
#' @param matrices matrix
#' @param title Title to give to plot setting matrices
#' @return a ggplot
#' @examples
#' \dontrun{
#' if (interactive()) {
#' 
#'  polymod_contact_data <- get_polymod_setting_data()
#' polymod_survey_data <- get_polymod_population()
#' 
#' setting_models <- fit_setting_contacts(contact_data_list = polymod_contact_data,
#'                        population = polymod_survey_data)
#' 
#' fairfield_age_pop <- abs_age_lga("Fairfield (C)")
#' 
#' fairfield_hh_size <-
#'   get_per_capita_household_size(lga = "Fairfield (C)")
#' 
#' synthetic_settings_5y_fairfield_hh <- predict_setting_contacts(
#'   population = fairfield_age_pop,
#'   contact_model = setting_models,
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   per_capita_household_size = fairfield_hh_size
#' )
#'
#' # Plotting synthetic contact matrices across all settings
#' 
#'  autoplot(object =  synthetic_settings_5y_fairfield_hh,
#'           title="Setting specific synthetic contact matrices")
#'  
#' # Work setting specific synthetic contact matrices
#'  autoplot(object =  synthetic_settings_5y_fairfield_hh$work,
#'           title="Work")
#' }
#' }
#' @export
autoplot.predicted_setting_contacts <- function(object, ...,title="Contact Matrices") {
  if (any(is.element(class(object), "matrix")))
  {
    object %>%
      matrix_to_predictions() %>%
      ggplot2::ggplot(ggplot2::aes(x = age_group_from,
                                   y = age_group_to,
                                   fill = contacts)) +
      ggplot2::geom_tile() +
      ggplot2::coord_fixed() +
      ggplot2::scale_fill_distiller(direction = 1,
                                    trans = "sqrt") +
      ggplot2::theme_minimal() +
      ggplot2::theme(axis.text = ggplot2::element_text(
        size = 6,
        angle = 45,
        hjust = 1
      ))+
      ggplot2::ggtitle(title)
  }
  else
  {
    do.call(patchwork::wrap_plots, lapply(names(object)[names(object) != "all"],
                                          function (x)
                                          {
                                            object[[x]] %>%
                                              matrix_to_predictions() %>%
                                              ggplot2::ggplot(ggplot2::aes(x = age_group_from,
                                                                           y = age_group_to,
                                                                           fill = contacts)) +
                                              ggplot2::geom_tile() +
                                              ggplot2::coord_fixed() +
                                              ggplot2::scale_fill_distiller(direction = 1,
                                                                            trans = "sqrt") +
                                              ggplot2::theme_minimal() +
                                              ggplot2::theme(axis.text = ggplot2::element_text(
                                                size = 6,
                                                angle = 45,
                                                hjust = 1
                                              )) +
                                              ggplot2::ggtitle(x)
                                          })) -> plot
    
    plot +
      patchwork::plot_annotation(
        title = title
      )
  }
}

