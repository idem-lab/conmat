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

  # programatically add the offset term to the formula, so the model defines
  # information about the setting, without us having to pass it through to the
  # prediction data
  formula_no_offset <- contacts ~
    # Prem method did a post-hoc smoothing
    # abs(age_from - age_to)
      s(gam_age_offdiag) +
    # abs(age_from - age_to)^2
      s(gam_age_offdiag_2) +
    # abs(age_from * age_to)
      s(gam_age_diag_prod) +
    # abs(age_from + age_to)
      s(gam_age_diag_sum) +
    # pmax(age_from, age_to)
      s(gam_age_pmax) +
    # pmin(age_from, age_to)
      s(gam_age_pmin) +
    # probabilities of both attending (any) school/work
    school_probability +
    work_probability
  
  # choose the offset variable based on the setting
  setting <- contact_data$setting[1]
  offset_variable <- switch(
    setting,
    school = "log_contactable_population_school",
    "log_contactable_population"
  )
  
  # add multiplicative offset for population contactable, to enable
  # extrapolation to new demographies
  # in mgcv, this part of the offset gets used in prediction, which 
  # is what we want. Those are the "contactable" parts, which we use
  # to extrapolate to new demographics.
  formula_offset <- sprintf("~. + offset(%s)", offset_variable)
  formula <- update(formula_no_offset, formula_offset)
  
  # contact model for all locations together
  contact_data %>%
    # NOTE
    # Do we need to have this data cleaning step in here?
    # I think we should instead have this as a separate preparation step for
    # model fitting.
    add_modelling_features(
      # NOTE
      # The modelling features added here are:
        # the school and work offsets
        # pop_age_to (interpolated population)
        # `log_contactable_population_school`, and ` log_contactable_population`
      population = population
    ) %>%
    mgcv::bam(
      formula = formula,
      family = stats::poisson,
      # add number of participants as a multilpicative offset here rather than in
      # the formula, so it is not needed for prediction,
      # NOTE: the offset of participants allows us to get the rate per person
      offset = log(participants),
      data = .
    )
  
}
