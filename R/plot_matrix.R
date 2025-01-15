#' Visualise predicted contact matrix
#'
#' Visualising the predicted contact rates facilitates understanding the
#'   underlying patterns and relationships between age groups in different
#'   settings (workplace, home, school, other). The `plot_matrix()` function
#'   takes a contact matrix and visualises it, with the x and y axes being
#'   different age groups.
#'
#' @param matrix Square matrix with row and column names indicating the age
#'   groups
#' @return a ggplot visualisation of contact rates
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
#' # Visualise the projected contact rates for "home" in the Fairfield LGA. The
#' # strong diagonal shows us that similar age groups typically have higher
#' # rates of home contact. We can also see parental links include middle-aged
#' # age groups having observable contact rates with younger age groups.
#' # For instance, ages between 25 and 45 have higher contact rates with
#' # newborns (0 to 5) and children (5 to 10), but older age groups,
#' # including those over 55, tend to have higher contact rates with age
#' # groups between 25 and 45, showing the interactions between parents and
#' # children. In addition to this, other patterns that indicates contact
#' # between children and their grandparents where higher contact rates between
#' # young children (years 0-5) and grandparents (age 55+) are present.
#'
#'
#' plot_matrix(synthetic_settings_5y_fairfield$home)
#' }
#'
#' @noRd
#' @keywords internal
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
