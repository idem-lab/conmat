#' predict contacts to a given population at full 1y resolution
#'
#' @param model PARAM_DESCRIPTION
#' @param population PARAM_DESCRIPTION
#' @param age_min PARAM_DESCRIPTION, Default: 0
#' @param age_max PARAM_DESCRIPTION, Default: 100
#' @return OUTPUT_DESCRIPTION
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
predict_contacts_1y <- function(model, population, age_min = 0, age_max = 100) {
  
  all_ages <- age_min:age_max

  # predict contacts to all integer years, adjusting for the population in a given place
  tidyr::expand_grid(
    age_from = all_ages,
    age_to = all_ages,
  ) %>%
    # add on prediction features, setting the population to predict to
    add_modelling_features(
      population = population
    ) %>%
    dplyr::mutate(
      # prediction
      contacts = predict(
        model,
        newdata = .,
        type = "response"
      ),
      # uncertainty
      se_contacts = predict(
        model,
        newdata = .,
        type = "response",
        se.fit = TRUE
      )$se.fit
    ) %>%
    dplyr::select(
      age_from,
      age_to,
      contacts,
      se_contacts
    )
}
