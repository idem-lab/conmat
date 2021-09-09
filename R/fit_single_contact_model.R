#' fit a single GAM contact model to a dataset
#'
#' @param contact_data PARAM_DESCRIPTION
#' @param population PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
fit_single_contact_model <- function(contact_data, population) {

  # contact model for all locations together
  contact_data %>%
    # NOTE
    # Do we need to have this data cleaning step in here?
    # I think we should instead have this as a separate preparation step for
    # model fitting.
    add_modelling_features(
      population = population
    ) %>%
    mgcv::bam(
      contacts ~
      # multiplicative offset for population in the 'to' age group, to account for
      # opportunity to contact
      stats::offset(log(pop_age_to)) +
        # deviation of contact age distribution from population age distribution
        s(age_to) +
        # number of contacts by age
        s(age_from) +
        # intergenerational contact patterns
        s(abs(age_from - age_to)) +
        # interaction between intergenerational patterns and age_from, to remove
        # ridge for some ages and settings
        s(abs(age_from - age_to), age_from) +
        # probabilities of both attending (any) school/work
        school_probability +
        work_probability,
      family = stats::poisson,
      # add number of participants as a multilpicative offset here rather than in
      # the formula, so it is not needed for prediction,
      offset = log(participants),
      data = .
    )
}
