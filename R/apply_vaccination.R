#' Apply vaccination effects to next generation contact matrices
#' @param ngm next generation matrices. See [generate_ngm()] for creating next generation matrices of a state or a local government area for specific age groups
#' @param data data set with location specific information on vaccine coverage, efficacy of acquisition/susceptibility and efficacy of transmission/infectiousness for the ordered age groups from lowest to highest of the next generation matrix 
#' @param coverage_col bare variable name for the column with information on vaccine coverage by age groups
#' @param acquisition_col bare variable name for the column with information on efficacy of acquisition
#' @param transmission_col bare variable name for the column with information on efficacy of transmission
#' @export
#' @examples
#' 
#' vaccination_effect_example_data
#' ngm_NSW <- generate_ngm(state_name = "NSW", 
#'                         age_breaks = c(seq(0, 80, by = 5),Inf),
#'                         R_target = 1.5
#'                         ) 
#' ngm_5y_NSW_vacc_0.5 <- apply_vaccination(ngm = ngm_NSW,
#'                                          data=vaccination_effect_example_data,
#'                                          coverage_col=coverage,
#'                                          acquisition_col=acquisition,
#'                                          transmission_col=transmission)
#' 


apply_vaccination <- function(ngm,
                              data,
                              coverage_col,
                              acquisition_col,
                              transmission_col){

  
  transmission_reduction_matrix <- data %>%
  # compute percentage reduction in acquisition and transmission in each age group
  dplyr::mutate(
    acquisition_multiplier = 1 - {{ acquisition_col }} * {{ coverage_col }},
    transmission_multiplier = 1 - {{ transmission_col }} * {{ coverage_col }},
  ) %>%
  dplyr::select(-c(
    {{ coverage_col }},
    {{ acquisition_col }},
    {{ transmission_col }})
  )%>%
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
  
ngm_vaccinated=Map('*',ngm,transmission_reduction_matrix)
return(ngm_vaccinated)

}

