#' @title Calculate next generation contact matrices
#'
#' @description Once infected, a person can transmit an infectious disease to
#'   another, creating generations of infected individuals. We can define a
#'   matrix describing the number of newly infected individuals in given
#'   categories, such as age, for consecutive generations. This matrix is
#'   called a "next generation matrix" (NGM).
#'
#' @details The NGM can be used to calculate the expected number of secondary
#'   infections in a given age group. Given certain age breaks, we compute the
#'   unscaled next generation matrices for that location across different
#'   settings & age groups using the contact rates extrapolated from POLYMOD
#'   survey data on the specified location, adjusted by the per capita
#'   household size and the setting-specific relative per-contact transmission
#'   probability matrices for the same age groups. These NGMs are then scaled
#'   according to a target reproduction number (which is provided as an
#'   argument) using the ratio of the desired R0 and the R0 of the NGM
#'   for the combination of all settings. The R0 of the combination of all
#'   settings is obtained by calculating the unique, positive eigen value of
#'   the combination NGM. This ratio is then used to scale all the setting
#'   specific NGMs.
#'
#' @param state_name target Australian state name in abbreviated form, such
#'   as "QLD", "NSW", or "TAS"
#' @param lga_name target Australian local government area (LGA) name, such
#'   as "Fairfield (C)".  See [abs_lga_lookup()] for list of lga names.
#' @param age_breaks vector depicting age values with the highest age depicted
#'   as `Inf`. For example, c(seq(0, 85, by = 5), Inf)
#' @param R_target target reproduction number
#'
#' @export
#' @examples
#' # don't run as both together takes a long time to run
#' \dontrun{
#' ngm_nsw <- generate_ngm(
#'   state_name = "NSW",
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   R_target = 1.5
#' )
#' ngm_fairfield <- generate_ngm(
#'   lga_name = "Fairfield (C)",
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   R_target = 1.5
#' )
#' }
generate_ngm <- function(state_name = NULL,
                         lga_name = NULL,
                         age_breaks,
                         R_target) {
  # pull out the age distribution of the target population &
  # the per-capita (ie. averaged over people, not households) household
  # size in this population
  if (!is.null(state_name)) {
    population <- abs_age_state(state_name = {{ state_name }})
    household_size <- get_per_capita_household_size(state = {{ state_name }})
  } else {
    population <- abs_age_lga(lga_name = {{ lga_name }})
    household_size <- get_per_capita_household_size(lga = {{ lga_name }})
  }
  # predict from the model to contact rates for a population with these characteristics,
  # and for these age breaks

  setting_contact_rates <- extrapolate_polymod(population,
    age_breaks = age_breaks,
    per_capita_household_size = household_size
  )

  # get relative (ie. needing to be scaled to a given R) transmission
  # probabilities between pairs of ages in different settings - these incorporate
  # relative infectiousness by age (based on symptomatic fraction), relative
  # susceptibility by age, and setting-specific weights to account for different
  # transmission probabilities in different settings, calibrated to UK infection
  # survey data.

  setting_rel_transmission_probs <- get_setting_transmission_matrices(age_breaks = age_breaks)

  # combine to get relative setting-specific NGMs - keeping the four settings in
  # the right order

  settings <- names(setting_rel_transmission_probs)
  setting_rel_ngms <- mapply("*",
    setting_contact_rates[settings],
    setting_rel_transmission_probs[settings],
    SIMPLIFY = FALSE
  )

  # add an 'all locations' matrix, so we can scale the whole thing
  setting_rel_ngms$all <- Reduce("+", setting_rel_ngms)

  # scale to a required R_target
  # the eigenvalue is the R
  R_raw <- Re(eigen(setting_rel_ngms$all)$values[1])
  scaling <- R_target / R_raw

  # could be lapply
  setting_ngms <- mapply("*",
    setting_rel_ngms,
    scaling,
    SIMPLIFY = FALSE
  )

  new_ngm_setting_matrix(setting_ngms)
}
