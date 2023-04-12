#' Get Setting Transmission Matrices
#'
#' Given some age breaks, return a named list of matrices containing
#' age-specific relative per-contact transmission probability matrices for each
#' of 4 settings: home, school, work, other. These can be combined with contact
#' matrices to produce setting-specific relative next generation matrices
#' (NGMs). These can be scaled to match a required reproduction number based on
#' the dominant eigenvalue of the all-settings NGM (the elementwise sum of all
#' setting NGMs).
#'
#' These matrices are created from: an estimate of the clinical fraction for
#' each age (inferred by applying a smoothing spline to the mean estimates from
#' Davies et al.); an assumption of the infectiousness of asymptomatics relative
#' to symptomatics (provided as an argument); estimates of the relative
#' susceptibility to infection of individuals of different ages, inferred from a
#' smoothing-spline estimate of the mean relative susceptibility estimate from
#' Davies et al., combined with a re-estimation of the susceptibility profile
#' for under-16s, estimated in a similar way but to the age-distribution of
#' infections in England from the UK ONS prevalence survey (rather than case
#' counts with may undercount children), assuming the above clinical fraction
#' estimates, and accounting for vaccination, reduced mixing, and reduced
#' transmissibility in work and other settings due to hygiene behaviour; and
#' estimates of the relative transmissibility in household vs non-household
#' settings - scaled linearly for non-household transmission and binomially for
#' household transmission (so that onward infections do not to exceed the number
#' of other household members).
#'
#' When using this data, ensure that you cite this package, and the original
#' authors of the paper from which these estimates were derived:
#'
#' Davies, N.G., Klepac, P., Liu, Y. et al. Age-dependent effects in the
#' transmission and control of COVID-19 epidemics. Nat Med 26, 1205–1211 (2020).
#' https://doi.org/10.1038/s41591-020-0962-9
#'
#' @param age_breaks vector of age breaks, defaults to
#'   `c(seq(0, 80, by = 5), Inf)`
#' @param asymptomatic_relative_infectiousness the assumed ratio of onward
#'   infectiousness between asymptomatic and symptomatic cases. This represents
#'   the infectiousness of asymptomatic relative to symptomatic.
#'   Default value is 0.5, which means the asymptomatic cases are 50% less
#'   infectious than symptomatic cases.
#' @param susceptibility_estimate Which estimate to use for susceptibility by
#'   age. Either, the smoothed original Davies et al estimates,
#'   "davies_original" or, the set updated to match UK under-16 infections
#'    (the default), "davies_updated".
#'
#' @return list of matrices, containing the relative per-contact transmission
#'   probability for each setting
#' @export
#'
#' @examples
#' \dontrun{
#' # fit polymod model
#' setting_models <- fit_setting_contacts(
#'   contact_data_list = get_polymod_setting_data(),
#'   population = get_polymod_population()
#' )
#'
#' # define age breaks for prediction
#' age_breaks <- c(seq(0, 80, by = 5), Inf)
#'
#' # define a new population age distribution to predict to
#' fairfield <- abs_age_lga("Fairfield (C)")
#'
#' # predict setting-specific contact matrices to a new population
#' contact_matrices <- predict_setting_contacts(
#'   population = fairfield,
#'   contact_model = setting_models,
#'   age_breaks = age_breaks
#' )
#'
#' # remove the 'all' matrix, keep the other four settings
#' contact_matrices <- contact_matrices[c("home", "school", "work", "other")]
#'
#' # get setting-specific per-contact transmission rate matrices for the same
#' # age aggregations
#' transmission_matrices <- get_setting_transmission_matrices(
#'   age_breaks = age_breaks
#' )
#'
#' # combine them to get setting-specific (unscaled) next-generation matrices
#' next_generation_matrices <- mapply(
#'   FUN = `*`,
#'   contact_matrices,
#'   transmission_matrices,
#'   SIMPLIFY = FALSE
#' )
#'
#' # get the all-settings NGM
#' ngm_overall <- Reduce("+", next_generation_matrices)
#' }
get_setting_transmission_matrices <- function(age_breaks = c(seq(0, 80, by = 5), Inf),
                                              asymptomatic_relative_infectiousness = 0.5,
                                              susceptibility_estimate = c("davies_updated", "davies_original")) {
  if (!dplyr::last(is.infinite(age_breaks))) {
    age_breaks <- c(age_breaks, Inf)
  }

  # which parameter estimates to use for susceptibility by age
  susceptibility_estimate <- rlang::arg_match(susceptibility_estimate)

  # format the setting transmission scalings (calibrated for these transmission
  # probabilities and conmat contact matrices against English infection data)
  # into a tibble to join to the transmission probabilities
  setting_weights_tibble <- tibble::tibble(
    setting = names(setting_weights),
    weight = setting_weights
  )

  # load the age-dependent susceptibility and clinical fraction parameters, and
  # convert into infectiousness and susceptibility
  age_effects <- davies_age_extended %>%
    dplyr::filter(age <= max(age_breaks)) %>%
    dplyr::mutate(
      infectiousness = clinical_fraction + (1 - clinical_fraction) *
        asymptomatic_relative_infectiousness
    ) %>%
    # select which set to use
    dplyr::select(
      age,
      infectiousness,
      susceptibility = !!susceptibility_estimate
    )

  # expand out to all settings and age combinations
  data <- tidyr::expand_grid(
    setting = setting_weights_tibble$setting,
    age_from = age_effects$age,
    age_to = age_effects$age
  ) %>%
    dplyr::left_join(
      dplyr::select(
        age_effects,
        age_from = age,
        infectiousness
      ),
      by = "age_from"
    ) %>%
    dplyr::left_join(
      dplyr::select(
        age_effects,
        age_to = age,
        susceptibility
      ),
      by = "age_to"
    ) %>%
    # aggregate them to the required age ranges
    dplyr::mutate(
      age_group_to = cut(pmax(0.1, age_to), age_breaks, right = FALSE),
      age_group_from = cut(pmax(0.1, age_from), age_breaks, right = FALSE),
      .after = setting
    ) %>%
    dplyr::group_by(
      setting,
      age_group_from,
      age_group_to
    ) %>%
    dplyr::summarise(
      across(
        c(infectiousness, susceptibility),
        mean
      ),
      .groups = "drop"
    ) %>%
    # attach and apply the weights
    dplyr::left_join(
      setting_weights_tibble,
      by = "setting"
    ) %>%
    dplyr::mutate(
      relative_probability = infectiousness * susceptibility,
      probability = dplyr::case_when(
        setting == "home" ~ 1 - (1 - relative_probability)^weight,
        TRUE ~ relative_probability * weight
      )
    ) %>%
    dplyr::select(
      setting,
      age_group_from,
      age_group_to,
      probability
    )

  matrices <- data %>%
    # convert into matrices
    tidyr::nest(
      matrix = c(
        age_group_from,
        age_group_to,
        probability
      )
    ) %>%
    dplyr::mutate(
      matrix = lapply(
        matrix,
        tidyr::pivot_wider,
        names_from = age_group_from,
        values_from = probability
      ),
      matrix = lapply(
        matrix,
        tibble::column_to_rownames,
        "age_group_to"
      ),
      matrix = lapply(
        matrix,
        as.matrix
      )
    ) %>%
    # turn this into a list to return
    tidyr::pivot_wider(
      names_from = setting,
      values_from = matrix
    ) %>%
    as.list() %>%
    lapply(purrr::pluck, 1)

  new_transmission_probability_matrix(
    matrices[c("home", "school", "work", "other")]
  )
}
