#' @title Predict contact rate to a given population at full 1y resolution
#'
#' @description Provides a predicted rate of contacts for contact ages.
#'   Take an already fitted model of contact rate and predict the
#'   estimated contact rate, and standard error, for all combinations of the 
#'   provided ages in 1 year increments. So if the minimum age is 5, and the 
#'   maximum age is 10, it will provide the estimated contact rate for all age 
#'   combinations: 5 and 5, 5 and 6 ... 5 and 10, and so on. This function is 
#'   used internally within [predict_contacts()], and thus 
#'   [predict_setting_contacts()] as well, although it can be used by itself.
#'   See examples for more details, and details for more information.
#'  
#' @details Prediction features are added using [add_modelling_features()]. 
#'   These features include the population distribution of contact ages, 
#'   fraction of population in each age group that attend school/work as well 
#'   as the offset according to the settings on all combinations of the
#'   participant & contact ages.
#'   
#' @param model A single fitted model of contact rate (e.g.,
#'    [fit_single_contact_model()]) 
#' @param population a dataframe of age population information, with columns 
#'    indicating some lower age limit, and population, (e.g., 
#'    [get_polymod_population()])
#' @param age_min Age range minimum value. Default: 0
#' @param age_max Age range maximum value, Default: 100
#' @return Data frame with four columns: `age_from`, `age_to`, `contacts`, and
#'   `se_contacts`. This contains the participant & contact ages from the 
#'   minimum and maximum ages provided along with the predicted rate of 
#'   contacts and standard error around the prediction.
#' @examples
#' 
#' fairfield_abs_data <- abs_age_lga("Fairfield (C)")
#' 
#' fairfield_abs_data
#' 
#' # predict the contact rates in 1 year blocks to Fairfield data
#' 
#' fairfield_contacts_1 <- predict_contacts_1y(
#'   model = polymod_setting_models$home,
#'   population = fairfield_abs_data,
#'   age_min = 0,
#'   age_max = 2
#' )
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
