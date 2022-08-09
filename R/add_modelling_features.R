#' Add features required for modelling to the dataset
#' 
#' This function adds three main groups of features to the data. It is used
#'   internally in [fit_single_contact_model()] and [predict_contacts_1y()].
#'  It requires columns named `age_to` and `age_from`. The three types of 
#'  features it adds are described below:
#'   1) Population distribution of contact ages from the function 
#'     [add_population_age_to()], which requires a column called "age_to" 
#'     representing the age of the person who had contact. It creates a column
#'     called `pop_age_to`. [add_population_age_to()] takes an extra argument
#'     for population, which defaults to [get_polymod_population()], but needs
#'     to be a data frame with columns, `lower.age.limit`, and `population`.
#'   2) School work participation, which is from the function 
#'     [add_school_work_participation()]. This requires columns `age_to` and 
#'     `age_from`, but will operate on any column starting with `age` and adds
#'     columns: `school_probability`, `work_probability`, 
#'     `school_year_probability`, and `school_weighted_pop_fraction`.
#'   3) Offset is added on to the data using [add_offset()]. This requires 
#'     variables `school_weighted_pop_fraction` (from 
#'     [add_school_work_participation()]) and `pop_age_to` (from 
#'     [add_school_work_participation()]). It adds two columns, 
#'     `log_contactable_population_school`, and `log_contactable_population`.
#'
#' @param contact_data contact data with columns `age_to` and `age_from`
#' @param ... extra dots passed to `population` argument of 
#'   [add_population_age_to()]
#' @return data frame with 11 extra columns - the contents of `contact_data`,
#'   plus:  pop_age_to, school_fraction_age_from, work_fraction_age_from, 
#'     school_fraction_age_to, work_fraction_age_to, school_probability, 
#'     work_probability, school_year_probability, school_weighted_pop_fraction, 
#'     log_contactable_population_school, and log_contactable_population.
#' @examples
#' age_min <- 10
#' age_max <- 15
#' all_ages <- age_min:age_max
#' library(tidyr)
#' example_df <- expand_grid(
#'    age_from = all_ages,
#'    age_to = all_ages,
#'    )
#' add_modelling_features(example_df) 
#' @export
add_modelling_features <- function(contact_data, ...) {
  
  # use interpolated population of "age_to" (contact age) & 
  # get the relative population grouped by "age_from" or participant age
  # add new variables for: 
    # school & work going fraction for contact & participant ages
    # probability that a person of the other age goes to the same  work/school 
    # probability that a person of the other age would be in the same school year
    # weighted combination of contact population & school year probability. 
  #                       [ for using outside of classroom?]
  # offset for school setting & the rest. 
   contact_data %>%
    # Adds interpolated age population - specifically, `pop_age_to`
    add_population_age_to(...) %>%
    # Adds school and work offset
    add_symmetrical_features() %>%
    add_school_work_participation() %>%
    # adds columns 
    # `log_contactable_population_school`, and ` log_contactable_population`
    add_offset()
}
