#' @title Calculate next generation contact matrices
#'
#' @description Once infected, a person can transmit an infectious disease to
#'   another, creating generations of infected individuals. We can define a
#'   matrix describing the number of newly infected individuals in given
#'   categories, such as age, for consecutive generations. This matrix is
#'   called a "next generation matrix" (NGM). We can generate an NGM from two
#'   sources - a `conmat_population` object (such as the output from
#'   [abs_age_lga()]), or a `conmat_setting_prediction_matrix`, which is the
#'   output from [extrapolate_polymod()] or [predict_setting_contacts()].
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
#' @note When using a setting prediction contact matrix (such as one generated
#'   by `extrapolate_polymod`, with class `conmat_setting_prediction_matrix`),
#'   the age breaks specified in `generate_ngm` must be the same as the age
#'   breaks specified in the synthetic contact matrix, otherwise it will error
#'   as it is trying to multiple incompatible matrices.
#'
#' @param x data input - could be a `conmat_population` (such as the output from
#'   [abs_age_lga()]), or a `conmat_setting_prediction_matrix`, which is the
#'   output from [extrapolate_polymod()] or [predict_setting_contacts()].
#' @param age_breaks vector depicting age values with the highest age depicted
#'   as `Inf`. For example, c(seq(0, 85, by = 5), Inf)
#' @param R_target target reproduction number
#' @param setting_transmission_matrix default is NULL, which calculates the transmission
#'   matrix using `get_setting_transmission_matrices(age_breaks)`. You can
#'   provide your own transmission matrix, but its rows and columns must match
#'   the number of rows and columns, and must be a list of one matrix for each
#'   setting. See the output for `get_setting_transmission_matrices(age_breaks)`
#'   to get a sense of the structure. See [get_setting_transmission_matrices()]
#'   for more detail.
#' @param ... extra arguments, currently not used
#' @name generate_ngm
#' @examples
#' \dontrun{
#' perth <- abs_age_lga("Perth (C)")
#' perth_hh <- get_abs_per_capita_household_size(lga = "Perth (C)")
#'
#' age_breaks_0_80_plus <- c(seq(0, 80, by = 5), Inf)
#'
#' # you can also run this without `per_capita_household_size`
#' perth_ngm_lga <- generate_ngm(
#'   perth,
#'   age_breaks = age_breaks_0_80_plus,
#'   per_capita_household_size = perth_hh,
#'   R_target = 1.5
#' )
#'
#' perth_contact <- extrapolate_polymod(
#'   perth,
#'   per_capita_household_size = perth_hh
#' )
#'
#' perth_ngm <- generate_ngm(
#'   perth_contact,
#'   age_breaks = age_breaks_0_80_plus,
#'   R_target = 1.5
#' )
#'
#' # using our own transmission matrix
#' new_transmission_matrix <- get_setting_transmission_matrices(
#'   age_breaks = age_breaks_0_80_plus,
#'   # is normally 0.5
#'   asymptomatic_relative_infectiousness = 0.75
#' )
#'
#' new_transmission_matrix
#'
#' perth_ngm_0_80_new_tmat <- generate_ngm(
#'   perth_contact,
#'   age_breaks = age_breaks_0_80_plus,
#'   R_target = 1.5,
#'   setting_transmission_matrix = new_transmission_matrix
#' )
#' }
#' @export
generate_ngm <- function(x,
                         age_breaks,
                         R_target,
                         setting_transmission_matrix,
                         ...) {
  # detect if state_name or lga_name are used
  # then give an informative error that the user should use
  # `generate_ngm_oz`
  # instead
  # state_name
  # lga_name
  UseMethod("generate_ngm")
}

#' @param lga_name now defunct, but capturing arguments for informative error
#' @param state_name now defunct, but capturing arguments for informative error
#' @examples
#' # examples not run as they take a long time
#' \dontrun{
#' perth <- abs_age_lga("Perth (C)")
#' perth_contact <- extrapolate_polymod(perth)
#' generate_ngm(perth_contact, age_breaks = c(seq(0, 85, by = 5), Inf))
#' }
#' @rdname generate_ngm
#' @export
generate_ngm.conmat_setting_prediction_matrix <- function(x,
                                                          age_breaks,
                                                          R_target,
                                                          setting_transmission_matrix = NULL,
                                                          per_capita_household_size = NULL,
                                                          ...,
                                                          lga_name,
                                                          state_name) {
  if (!missing(state_name)) {
    error_old_ngm_arg(state_name)
  }
  if (!missing(lga_name)) {
    error_old_ngm_arg(lga_name)
  }

  check_age_breaks(
    x = age_breaks(x),
    y = age_breaks,
    x_arg = "x",
    y_arg = "age_breaks"
  )

  setting_transmission_matrix <- check_transmission_probabilities(
    setting_transmission_matrix,
    age_breaks = age_breaks
  )

  calculate_ngm(
    setting_prediction_matrix = x,
    age_breaks,
    R_target,
    setting_transmission_matrix = setting_transmission_matrix
  )
}

#' @param per_capita_household_size default is NULL - which defaults to [get_polymod_per_capita_household_size()], which gives 3.248971
#' @rdname generate_ngm
#' @export
generate_ngm.conmat_population <- function(x,
                                           age_breaks,
                                           R_target,
                                           setting_transmission_matrix = NULL,
                                           per_capita_household_size = NULL,
                                           ...,
                                           lga_name,
                                           state_name) {
  setting_contact_rates <- extrapolate_polymod(
    population = x,
    age_breaks = age_breaks,
    per_capita_household_size = per_capita_household_size
  )

  check_age_breaks(
    x = age_breaks(setting_contact_rates),
    y = age_breaks,
    x_arg = "x",
    y_arg = "age_breaks"
  )

  setting_transmission_matrix <- check_transmission_probabilities(
    setting_transmission_matrix,
    age_breaks = age_breaks
  )

  calculate_ngm(
    setting_prediction_matrix = setting_contact_rates,
    age_breaks = age_breaks,
    R_target = R_target,
    setting_transmission_matrix = setting_transmission_matrix
  )
}

#' @title Calculate next generation contact matrices from ABS data
#'
#' @description This function calculates a next generation matrix (NGM)
#'   based on state or LGA data from the Australian Bureau of Statistics (ABS).
#'   For full details see [generate_ngm()].
#
#' @param state_name target Australian state name in abbreviated form, such
#'   as "QLD", "NSW", or "TAS"
#' @param lga_name target Australian local government area (LGA) name, such
#'   as "Fairfield (C)".  See [abs_lga_lookup()] for list of lga names.
#' @inheritParams generate_ngm
#'
#' @export
#' @examples
#' # don't run as both together takes a long time to run
#' \dontrun{
#' ngm_nsw <- generate_ngm_oz(
#'   state_name = "NSW",
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   R_target = 1.5
#' )
#' ngm_fairfield <- generate_ngm_oz(
#'   lga_name = "Fairfield (C)",
#'   age_breaks = c(seq(0, 85, by = 5), Inf),
#'   R_target = 1.5
#' )
#' }
generate_ngm_oz <- function(state_name = NULL,
                            lga_name = NULL,
                            age_breaks,
                            R_target,
                            setting_transmission_matrix = NULL) {
  # pull out the age distribution of the target population &
  # the per-capita (ie. averaged over people, not households) household
  # size in this population
  if (!is.null(state_name)) {
    population <- abs_age_state(state_name = {{ state_name }})
    household_size <- get_abs_per_capita_household_size(state = {{ state_name }})
  } else {
    population <- abs_age_lga(lga_name = {{ lga_name }})
    household_size <- get_abs_per_capita_household_size(lga = {{ lga_name }})
  }

  # predict from the model to contact rates for a population with these
  # characteristics, and for these age breaks

  setting_contact_rates <- extrapolate_polymod(
    population,
    age_breaks = age_breaks,
    per_capita_household_size = household_size
  )

  setting_transmission_matrix <- check_transmission_probabilities(
    setting_transmission_matrix,
    age_breaks = age_breaks
  )

  calculate_ngm(
    setting_prediction_matrix = setting_contact_rates,
    age_breaks = age_breaks,
    R_target = R_target,
    setting_transmission_matrix = setting_transmission_matrix
  )
}


calculate_ngm <- function(setting_prediction_matrix,
                          age_breaks,
                          R_target,
                          setting_transmission_matrix) {
  # get relative (ie. needing to be scaled to a given R) transmission
  # probabilities between pairs of ages in different settings - these incorporate
  # relative infectiousness by age (based on symptomatic fraction), relative
  # susceptibility by age, and setting-specific weights to account for different
  # transmission probabilities in different settings, calibrated to UK infection
  # survey data.

  # Need to double check that the ages match in each
  # in previous versions this would work
  # check_if_age_breaks_match(setting_transmission_matrix,
  #                           setting_prediction_matrix)

  # combine to get relative setting-specific NGMs - keeping the four settings in
  # the right order
  settings <- names(setting_transmission_matrix)
  setting_rel_ngms <- mapply(
    "*",
    setting_prediction_matrix[settings],
    setting_transmission_matrix[settings],
    SIMPLIFY = FALSE
  )

  # add an 'all locations' matrix, so we can scale the whole thing
  setting_rel_ngms$all <- Reduce("+", setting_rel_ngms)

  # scale to a required R_target
  # the eigenvalue is the R
  R_raw <- Re(eigen(setting_rel_ngms$all)$values[1])
  scaling <- R_target / R_raw

  # could be lapply
  setting_ngms <- mapply(
    "*",
    setting_rel_ngms,
    scaling,
    SIMPLIFY = FALSE
  )

  new_ngm_setting_matrix(setting_ngms,
    raw_eigenvalue = R_raw,
    scaling = scaling,
    age_breaks = age_breaks
  )
}

check_transmission_probabilities <- function(input_transmission_probs, age_breaks) {
  if (is.null(input_transmission_probs)) {
    input_transmission_probs <- get_setting_transmission_matrices(
      age_breaks = age_breaks
    )
  }

  if (!inherits(input_transmission_probs, "transmission_probability_matrix")) {
    cli::cli_abort(
      "Input {.var input_transmission_probs} must have class \\
      {.cls transmission_probability_matrix}"
    )
  }
  input_transmission_probs
}
