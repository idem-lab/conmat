#' @title Apply vaccination effects to next generation contact matrices
#'
#' @description Applies the effect of vaccination on the next generation of
#'   infections, to understand and describe the reduction of acquisition and
#'   transmission in each age group.
#'
#' @details Vaccination improves a person's immunity from a disease. When a
#'   sizable section of the population receives vaccinations or when vaccine
#'   coverage is sufficient enough, the likelihood that the unvaccinated
#'   population will contract the disease is decreased. This helps to slow
#'   infectious disease spread as well as lessen its severity. For this reason,
#'   it is important to understand how much of a reduction in probability of
#'   acquisition (the likelihood that an individual will contract the disease),
#'   and probability of transmission (the likelihood that an individual will
#'   spread the disease after contracting it), has occurred as an the effect of
#'   vaccination, in other words the effect of vaccination on the next
#'   generation of infections.
#'
#'   `apply_vaccination` returns the percentage reduction in acquisition and
#'   transmission in each age group. It does this by taking the outer product
#'   of these reductions in acquisition and transmission by age group, creating
#'   a transmission reduction matrix. The next generation matrices with the
#'   vaccination effects applied are then produced using the obtained
#'   transmission reduction matrix and the next generation matrices passed to
#'   the function as an argument.
#'
#' @param ngm next generation matrices. See [generate_ngm()] for creating next
#'   generation matrices of a state or a local government area for specific age
#'   groups
#'
#' @param data data frame with location specific information on vaccine
#'   coverage, efficacy of acquisition/susceptibility and efficacy of
#'   transmission/infectiousness for the ordered age groups from lowest to
#'   highest of the next generation matrix
#'
#' @param coverage_col bare variable name for the column with information on
#'   vaccine coverage by age groups
#' @param acquisition_col bare variable name for the column with information
#'   on efficacy of acquisition
#' @param transmission_col bare variable name for the column with information
#'   on efficacy of transmission
#'
#' @return list of contact matrices, one for each setting with reduction in
#'   transmission matching the next generation matrices
#'
#' @examples
#' # examples take 20 second to run so skipping
#' \dontrun{
#' # example data frame with vaccine coverage, acquisition and transmission
#' # efficacy of different age groups
#' vaccination_effect_example_data
#'
#' # Generate next generation matrices
#' # The number of age breaks must match the vaccination effect data
#' ngm_nsw <- generate_ngm(
#'   state_name = "NSW",
#'   age_breaks = c(seq(0, 80, by = 5), Inf),
#'   R_target = 1.5
#' )
#'
#' # Apply vaccination effect to next generation matrices
#' ngm_nsw_vacc <- apply_vaccination(
#'   ngm = ngm_nsw,
#'   data = vaccination_effect_example_data,
#'   coverage_col = coverage,
#'   acquisition_col = acquisition,
#'   transmission_col = transmission
#' )
#'}
#' @export
apply_vaccination <- function(
  ngm,
  data,
  coverage_col,
  acquisition_col,
  transmission_col
) {
  
  
  check_dimensions(ngm,data)
  
  transmission_reduction_matrix <- data %>%
    # compute percentage reduction in acquisition and transmission in each age group
    dplyr::mutate(
      acquisition_multiplier = 1 - {{ acquisition_col }} * {{ coverage_col }},
      transmission_multiplier = 1 - {{ transmission_col }} * {{ coverage_col }},
    ) %>%
    dplyr::select(-c(
      {{ coverage_col }},
      {{ acquisition_col }},
      {{ transmission_col }}
    )) %>%
    # transform these into matrices of reduction in transmission, matching the NGM
    dplyr::summarise(
      transmission_reduction_matrix =
        list(
          outer(
            # 'to' groups are on the rows in conmat, and first element in outer is rows,
            # so acquisition first
            acquisition_multiplier,
            transmission_multiplier,
            FUN = "*"
          )
        ),
      .groups = "drop"
    ) %>%
    dplyr::pull(transmission_reduction_matrix)

  ngm_vaccinated <- Map("*", ngm, transmission_reduction_matrix)
  return(ngm_vaccinated)
}
