#' @title Predict contact rate between two age populations, given some model.
#'
#' @description Predicts the expected contact rate over specified age breaks,
#'  given some model of contact rate and population age structure.
#'  This function is used internally in [predict_setting_contacts()], which
#'  performs this prediction across all settings (home, work, school, other),
#'  and optionally performs an adjustment for per capita household size. You
#'  can use `predict_contacts()` by itself, just be aware you will need to
#'  separately apply a per capita household size adjustment if required. See
#'  details below on `adjust_household_contact_matrix` for more information.
#'
#' @details The population data is used to determine age range to predict
#'   contact rates, and removes ages with zero population, so we do not
#'   make predictions for ages with zero populations. Contact rates are
#'   predicted yearly between the age groups, using [predict_contacts_1y()],
#'   then aggregates these predicted contacts using
#'   [aggregate_predicted_contacts()], which aggregates the predictions back to
#'   the same resolution as the data, appropriately weighting the contact rate
#'   by the population.
#'
#'   Regarding the `adjust_household_contact_matrix` function, we use
#'     Per-capita household size instead of mean household size.
#'     Per-capita household size is different to mean household size, as the
#'     household size averaged over people in the **population**, not over
#'     households, so larger households get upweighted. It is calculated by
#'     taking a distribution of the number of households of each size in a
#'     population, multiplying the size by the household by the household count
#'     to get the number of people with that size of household, and computing
#'     the population-weighted average of household sizes. We use per-capita
#'     household size as it is a more accurate reflection of the average
#'     number of household members a person in the population can have contact
#'     with.
#'
#' @param model A single fitted model of contact rate (e.g.,
#'    [fit_single_contact_model()])
#' @param population a dataframe of age population information, with columns
#'    indicating some lower age limit, and population, (e.g., [get_polymod_population()])
#' @param age_breaks the ages to predict to. By default, the age breaks are
#'    0-75 in 5 year groups.
#' @return A dataframe with three columns: `age_group_from`, `age_group_to`,
#'   and  `contacts`. The age groups are factors, broken up into 5 year bins
#'   `[0,5)`, `[5,10)`. The `contact` column is the predicted number of
#'   contacts from the specified age group to the other one.
#' @examples
#' # If we have a model of contact rate at home, and age population structure
#' # for an LGA, say, Fairfield, in NSW:
#'
#' polymod_setting_models$home
#'
#' fairfield <- abs_age_lga("Fairfield (C)")
#'
#' fairfield
#'
#' # We can predict the contact rate for Fairfield from the existing contact
#' # data, say, between the age groups of 0-15 in 5 year bins for school:
#'
#' fairfield_school_contacts <- predict_contacts(
#'   model = polymod_setting_models$school,
#'   population = fairfield,
#'   age_breaks = c(0, 5, 10, 15, Inf)
#' )
#'
#' fairfield_school_contacts
#'
#' @export
predict_contacts <- function(model,
                             population,
                             age_breaks = c(seq(0, 75, by = 5), Inf)) {
  age <- age(population)
  age_var <- age_label(population)
  population <- population %>%
    dplyr::arrange(!!age)

  # this could be changed to a function for lower age limit
  age_min_integration <- min(population[[age_var]])
  bin_widths <- diff(population[[age_var]])
  final_bin_width <- bin_widths[length(bin_widths)]
  age_max_integration <- max(population[[age_var]]) + final_bin_width

  # need to check we are not predicting to 0 populations (interpolator can
  # predict 0 values, then the aggregated ages get screwed up)
  pop_fun <- get_age_population_function(population)
  ages <- age_min_integration:age_max_integration
  valid <- pop_fun(ages) > 0
  age_min_integration <- min(ages[valid])
  age_max_integration <- max(ages[valid])

  pred_1y <- predict_contacts_1y(
    model = model,
    population = population,
    # these two arguments could be changed by just taking in the age vector
    # and then doing that step above internally
    age_min = age_min_integration,
    age_max = age_max_integration
  )

  pred_groups <- aggregate_predicted_contacts(
    predicted_contacts_1y = pred_1y,
    population = population,
    age_breaks = age_breaks
  )

  new_predicted_contacts(
    pred_groups,
    age_breaks = age_breaks
  )
}
