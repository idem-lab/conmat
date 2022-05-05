#' Get next generation contact matrices
#' @param state_name target Australian state name in abbreviated form, such as "QLD", "NSW", or "TAS"
#' @param lga_name target Australian local government area (LGA) name, such as "Fairfield (C)".  See 
#'   [abs_lga_lookup()] for list of lga names
#' @param age_breaks vector depicting age values with the highest age depicted as `Inf`. For example, c(seq(0, 85, by = 5), Inf)
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
 
   if (!is.null(state_name)){
    population <- abs_age_state(state_name = {{ state_name }})
    household_size <- get_per_capita_household_size(state = {{ state_name }})
  } else{
    population <- abs_age_lga(lga_name = {{ lga_name }})
    household_size <- get_per_capita_household_size(lga = {{ lga_name }})
  }
  # predict from the model to contact rates for a population with these characteristics, 
  # and for these age breaks
  
  setting_contact_rates <- extrapolate_polymod(population,
                                               age_breaks = age_breaks,
                                               per_capita_household_size = household_size)
 
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
                             SIMPLIFY = FALSE)
  
  # add an 'all locations' matrix, so we can scale the whole thing
  setting_rel_ngms$all <- Reduce("+", setting_rel_ngms)
  
  # scale to a required R_target
  R_raw <- Re(eigen(setting_rel_ngms$all)$values[1])
  scaling <- R_target / R_raw
  
  setting_ngms <- mapply("*",
                         setting_rel_ngms,
                         scaling,
                         SIMPLIFY = FALSE)
  
  setting_ngms
}

