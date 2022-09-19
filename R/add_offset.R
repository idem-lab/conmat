#' @title Adds offset variables
#' 
#' @description Mostly used internally in `add_modelling_features()`. Adds two 
#'   offset variables to be used in [fit_single_contact_model()]:
#'   1) `log_contactable_population_school`, and 
#'   2) `log_contactable_population`.
#'   These two variables require variables `school_weighted_pop_fraction` (from 
#'     [add_school_work_participation()]) and `pop_age_to` (from
#'     [add_school_work_participation()]). This provides separate offsets
#'     for school setting when compared to the other settings such as home, 
#'     work and other. The offset for school captures cohorting of students 
#'     for schools and takes the logarithm of the weighted combination of 
#'     contact population age distribution & school year probability calculated 
#'     in [add_school_work_participation()]. See "details" for more information.
#'     
#' @details why double offsets? There are two offsets specified, once in the 
#'   model formula, and once in the "offset" argument of `mgcv::bam`. The 
#'   offsets get added together when the model first fit. In addition, the 
#'   setting specific offset from  `offset_variable`, which is included in the 
#'   GAM model as `... + offset(log_contactable_population)` is used in 
#'   prediction, whereas the other offset, included as an argument in the GAM 
#'   as `offset = log(participants)` is only included when the model is 
#'   initially created. See more detail in [fit_single_contact_model()].
#' 
#' @return data.frame of `contact_data` with two extra columns: 
#'   `log_contactable_population_school` and `log_contactable_population`
#' @param contact_data contact data - must contain columns `age_to`, `age_from`,
#'   `pop_age_to` (from [add_population_age_to()], and 
#'   `school_weighted_pop_fraction` (from [add_school_work_participation()])).
#' @author Nick Golding
#' @export
#' @examples
#' age_min <- 10
#' age_max <- 15
#' all_ages <- age_min:age_max
#' library(tidyr)
#' example_df <- expand_grid(
#'    age_from = all_ages,
#'    age_to = all_ages,
#'    )
#' example_df %>% 
#'  add_population_age_to() %>%
#'  add_school_work_participation() %>%
#'  add_offset() 
add_offset <- function(contact_data) {

  # define the offset variable for the model: the log population for most
  # settings, one that captures cohorting of students for schools. Define both,
  # and set the choice of which one in the model formula
  contact_data %>%
    dplyr::mutate(
      log_contactable_population_school = log(school_weighted_pop_fraction),
      log_contactable_population = log(pop_age_to)
    )

}
