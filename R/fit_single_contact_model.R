#' @title Fit a single GAM contact model to a dataset
#'
#' @description This is the workhorse of the `conmat` package, and is typically
#'   used inside [fit_setting_contacts()]. It predicts the contact rate between
#'   all age bands (the contact rate between ages 0 and 1, 0 and 2, 0 and 3,
#'   and so on), for a specified setting, with specific terms being added for
#'   given settings. See "details" for further information.
#'
#' @details The model fit is a Generalised Additive Model (GAM). We provide two
#'   "modes" for model fitting. Either using "symmetric" or "non-symmetric"
#'   model predictor terms with the logical variance "symmetrical", which is set
#'   to TRUE by default. We recommend using the "symmetrical" terms as it
#'   reflects the fact that contacts are symmetric - person A having contact
#'   with person B means person B has had contact with person A. We've included
#'   a variety of terms to account for assortativity with age, where people of
#'   similar ages have more contact with each other. And included terms to
#'   account for intergenerational contact patterns, where parents and
#'   grandparents will interact with their children and grand children.
#'   These terms are fit with a smoothing function. Specifically, the relevant
#'   code looks like this:
#'
#'   ``` r
#'   # abs(age_from - age_to)
#'   s(gam_age_offdiag) +
#'   # abs(age_from - age_to)^2
#'   s(gam_age_offdiag_2) +
#'   # abs(age_from * age_to)
#'   s(gam_age_diag_prod) +
#'   # abs(age_from + age_to)
#'   s(gam_age_diag_sum) +
#'   # pmax(age_from, age_to)
#'   s(gam_age_pmax) +
#'   # pmin(age_from, age_to)
#'   s(gam_age_pmin)
#'   ```
#'
#'   We also include predictors for the probability of attending school, and
#'   attending work. These are computed as the probability that a person goes
#'   to the same school/work, proportional to the increase in contacts due to
#'   attendance. These terms are calculated from estimated proportion of
#'   people in age groups attending school and work. See
#'   [add_modelling_features()] for more details.
#'
#'   Finally, we include two offset terms so that we estimate the contact rate,
#'   that is the contacts per capita, instead of the number of contacts. These
#'   offset terms are `log(contactable_population)`, and
#'   `log(contactable_population_school)` when the model is fit to a school
#'   setting. The contactable population is estimated as the interpolated
#'   1 year ages from the data. For schools this is the contactable population
#'   weighted by the proportion of the population attending school.
#'
#'   This leaves us with a model that looks like so:
#'
#'   ``` r
#'   mgcv::bam(
#'     formula = contacts ~
#'       # abs(age_from - age_to)
#'       s(gam_age_offdiag) +
#'       # abs(age_from - age_to)^2
#'       s(gam_age_offdiag_2) +
#'       # abs(age_from * age_to)
#'       s(gam_age_diag_prod) +
#'       # abs(age_from + age_to)
#'       s(gam_age_diag_sum) +
#'       # pmax(age_from, age_to)
#'       s(gam_age_pmax) +
#'       # pmin(age_from, age_to)
#'       s(gam_age_pmin) +
#'       school_probability +
#'       work_probability +
#'       offset(log_contactable_population) +
#'       # or for school settings
#'       # offset(log_contactable_population_school)
#'       family = stats::poisson,
#'     offset = log(participants),
#'     data = population_data
#'   )
#'   ```
#'
#'   But if the term `symmetrical = FALSE` is used, you get:
#'
#'   ``` r
#'   mgcv::bam(
#'     formula = contacts ~
#'       s(age_to) +
#'       s(age_from) +
#'       s(abs(age_from - age_to)) +
#'       s(abs(age_from - age_to), age_from) +
#'       school_probability +
#'       work_probability +
#'       offset(log_contactable_population) +
#'       # or for school settings
#'       # offset(log_contactable_population_school)
#'       family = stats::poisson,
#'     offset = log(participants),
#'     data = population_data
#'   )
#'   ```
#'
#' @param contact_data dataset with columns `age_to`, `age_from`, `setting`,
#'  `contacts`, and `participants`. See [get_polymod_contact_data()] for
#'   an example dataset - or the dataset in examples below.
#' @param population `conmat_population` object, or data frame with columns
#'   `lower.age.limit` and `population`. See [get_polymod_population()] for
#'   an example.
#' @param symmetrical whether to enforce symmetrical terms in the model.
#'   Defaults to TRUE. See `details` for more information.
#' @param school_demographics (optional) defaults to census average proportion
#'    at school. You can provide a dataset with columns, "age" (numeric), and
#'    "school_fraction" (0-1), if you would like to specify these
#'    details. See `abs_avg_school` for the default values. If you would like to
#'    use the original school demographics used in conmat, these are provided in
#'    the dataset, `conmat_original_school_demographics`.
#' @param work_demographics (optional) defaults to census average proportion
#'    employed. You can provide a dataset with columns, "age" (numeric), and
#'    "work_fraction", if you would like to specify these details. See
#'    `abs_avg_work` for the default values. If you would like to
#'    use the original work demographics used in conmat, these are provided in
#'    the dataset, `conmat_original_work_demographics`.
#' @return single model
#' @examples
#' example_contact <- get_polymod_contact_data(setting = "home")
#' example_contact
#' example_population <- get_polymod_population()
#'
#' library(dplyr)
#'
#' example_contact_20 <- example_contact %>%
#'   filter(
#'     age_to <= 20,
#'     age_from <= 20
#'   )
#'
#' my_mod <- fit_single_contact_model(
#'   contact_data = example_contact_20,
#'   population = example_population
#' )
#'
#' # you can specify your own population data for school and work demographics
#' my_mod_diff_data <- fit_single_contact_model(
#'   contact_data = example_contact_20,
#'   population = example_population,
#'   school_demographics = conmat_original_school_demographics,
#'   work_demographics = conmat_original_work_demographics
#' )
#' @export
fit_single_contact_model <- function(contact_data,
                                     population,
                                     symmetrical = TRUE,
                                     school_demographics = NULL,
                                     work_demographics = NULL) {
  # programatically add the offset term to the formula, so the model defines
  # information about the setting, without us having to pass it through to the
  # prediction data

  if (symmetrical) {
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
      school_probability +
      work_probability
  } else if (!symmetrical) {
    formula_no_offset <- contacts ~
      # # deviation of contact age distribution from population age distribution
      s(age_to) +
      # # number of contacts by age
      s(age_from) +
      # # intergenerational contact patterns - enables the off-diagonals
      # # intergenerational is defined as:
      #   # intergenerational = abs(age_from - age_to)
      s(intergenerational) +
      # # interaction between intergenerational patterns and age_from, to remove
      # # ridge for some ages and settings
      s(intergenerational, age_from) +
      # probabilities of both attending (any) school/work
      school_probability +
      work_probability
  }

  # choose the offset variable based on the setting
  setting <- contact_data$setting[1]
  offset_variable <- switch(setting,
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
      population = population,
      school_demographics = school_demographics,
      work_demographics = work_demographics
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
