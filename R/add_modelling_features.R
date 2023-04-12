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
#'     to be a `conmat_population` object, which specifies the `age` and
#'     `population` characteristics, or a data frame with columns,
#'     `lower.age.limit`, and `population`.
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
#' @param population the `population` argument of [add_population_age_to()]
#' @param school_demographics (optional) defaults to census average proportion
#'    at school. You can provide a dataset with columns, "age" (numeric), and
#'    "school_fraction" (0-1), if you would like to specify these
#'    details. See `abs_avg_school` for the default values. If you would like to
#'    use the original school demographics used in conmat, these are provided in
#'    the dataset, `conmat_original_school_demographics`.
#' @param work_demographics (optional) defaults to census average proportion
#'    employed. You can provide a dataset with columns, "age" (numeric), and
#'    "work_fraction", if you would like to specify these details. See
#'    `abs_avg_work` for the default values. If you would like to
#'    use the original work demographics used in conmat, these are provided in
#'    the dataset, `conmat_original_work_demographics`.
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
#'   age_from = all_ages,
#'   age_to = all_ages,
#' )
#' add_modelling_features(example_df)
#' add_modelling_features(
#'   example_df,
#'   school_demographics = conmat_original_school_demographics,
#'   work_demographics = conmat_original_work_demographics
#' )
#'
#' @export
add_modelling_features <- function(contact_data,
                                   school_demographics = NULL,
                                   work_demographics = NULL,
                                   population = get_polymod_population()) {
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
    add_population_age_to(population = population) %>%
    # Adds school and work offset
    add_symmetrical_features() %>%
    add_school_work_participation(
      school_demographics = school_demographics,
      work_demographics = work_demographics
    ) %>%
    # adds columns
    # `log_contactable_population_school`, and ` log_contactable_population`
    add_offset()
}

#' Add column, "intergenerational"
#'
#' For modelling purposes it is useful to have a feature that is the absolute
#'   difference between `age_from` and `age_to` columns.
#'
#' @param data data.frame with columns `age_from`, and `age_to`
#'
#' @return data.frame with extra column, `intergenerational`
#'
#' @examples
#'
#' polymod_contact <- get_polymod_contact_data()
#'
#' polymod_contact %>% add_intergenerational()
#'
#' @export
add_intergenerational <- function(data) {
  data %>%
    dplyr::mutate(
      intergenerational = abs(age_from - age_to)
    )
}
