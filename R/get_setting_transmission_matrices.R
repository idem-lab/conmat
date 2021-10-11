#' Get Setting Transmission Matrices
#'
#' Given some age breaks, return a named list of matrices containing relative
#' per-contact transmission probability matrices for each of 4 settings: home,
#' school, work, other. These can be combined with contact matrices to produce
#' setting-specific relative next generation matrices (NGMs). These can be
#' scaled to match a required reproduction number based on the dominant
#' eigenvalue of the all-settings NGM (the elementwise sum of all setting NGMs)
#'
#' When using this data, ensure that you cite this package, and the original
#' authors of the paper from which these estimates were derived at:
#'
#' Eyre, D. W., Taylor, D., Purver, M., Chapman, D., Fowler, T., Pouwels, K. B.,
#' Walker, A. S., & Peto, T. E. (2021). The impact of SARS-CoV-2 vaccination on
#' Alpha & Delta variant transmission (Preprint). medRxiv 2021.09.28.21264260
#' https://doi.org/10.1101/2021.09.28.21264260
#'
#' @param age_breaks vector of age breaks, defaults to `c(seq(0, 80, by = 5),
#'   Inf)`
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
#' fairfield_age_pop <- abs_age_lga("Fairfield (C)")
#'
#' # predict setting-specific contact matrices to a new population
#' contact_matrices <- predict_setting_contacts(
#'   population = fairfield_age_pop,
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
get_setting_transmission_matrices <- function(
  age_breaks = c(seq(0, 80, by = 5), Inf)
  ) {
  
    # format the setting transmission scalings (calibrated for thesetransmission
    # probabilities and conmat contact matrices against English infection data)
    # into a tibble to join to the transmission probabilities
    setting_weights_tibble <- tibble::tibble(setting = names(setting_weights),
                                             weight = setting_weights)
    
    # aggregate the transmission probabilities according to the age breaks
    eyre_transmission_probabilities %>%
      dplyr::select(setting,
                    age_to = contact_age,
                    age_from = case_age,
                    probability) %>%
      dplyr::mutate(
        age_group_to = cut(pmax(0.1, age_to), age_breaks, right = FALSE),
        age_group_from = cut(pmax(0.1, age_from), age_breaks, right = FALSE),
      )  %>%
      dplyr::group_by(setting,
                      age_group_from,
                      age_group_to) %>%
      dplyr::summarise(across(probability,
                              mean),
                       .groups =  "drop") %>%
      # convert into matrices
      tidyr::nest(matrix = c(age_group_from, age_group_to, probability)) %>%
      dplyr::mutate(
        matrix = lapply(
          matrix,
          tidyr::pivot_wider,
          names_from = age_group_to,
          values_from = probability
        ),
        matrix = lapply(matrix,
                        tibble::column_to_rownames,
                        "age_group_from"),
        matrix = lapply(matrix,
                        as.matrix)
      ) %>%
      # pivot, to relabel the ones we want as per the contact settings, then pivot
      # back to long format
      tidyr::pivot_wider(names_from = setting,
                         values_from = matrix) %>%
      dplyr::select(
        home = household,
        school = work_education,
        work = work_education,
        other = work_education
      ) %>%
      tidyr::pivot_longer(cols = everything(),
                          names_to = "setting",
                          values_to = "matrix") %>%
      # add on the setting weights and multiply to reweight the relative probabilities
      dplyr::left_join(setting_weights_tibble,
                       by = "setting") %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        matrix = dplyr::case_when(
          setting == "home" ~ list(1 - (1 - matrix) ^ weight),
          TRUE ~ list(matrix * weight)
        )
      ) %>%
      # turn this into a list to return
      dplyr::select(-weight) %>%
      tidyr::pivot_wider(names_from = setting,
                         values_from = matrix) %>%
      as.list() %>%
      lapply(purrr::pluck,
             1)
    
  }
