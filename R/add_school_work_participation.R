#' Add columns describing the fractions of the population in each age group
#'   that attend school/work (average FTE)
#'
#' Add fractions of the population in each age group that attend school/work
#'   (average FTE) to compute the probability that both participant and
#'   contact attend school/work. Requires columns `age_to` and  `age_from`.
#'   Note that it will operate on any column starting with `age`. Adds columns:
#'   `school_probability`, `work_probability`, `school_year_probability`, and
#'   `school_weighted_pop_fraction`. The columns `school_probability` and
#'   `work_probability` represent the probability a person of the other age
#'   goes to the same work/school. `school_year_probability` represents the
#'   probability that a person of the other age would be in the same school
#'   year. `school_weighted_pop_fraction` represents the weighted combination
#'   of contact population age distribution & school year probability, so that
#'   if the contact is in the same school year, the weight is 1, and otherwise
#'   it is the population age fraction. This can be used as an offset, so that
#'   population age distribution can be used outside the classroom, but does
#'   not affect classroom contacts (which due to cohorting and regularised
#'   class sizes are unlikely to depend on the population age distribution).
#'
#' @param contact_data contact data containing columns: `age_to`, `age_from`,
#'   and `pop_age_to` (from [add_population_age_to()])
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
#' @return dataset with 9 extra columns: school_fraction_age_from,
#'   work_fraction_age_from, school_fraction_age_to, work_fraction_age_to,
#'   school_probability, work_probability, school_year_probability, and
#'   school_weighted_pop_fraction.
#' @note To use previous approach input the arguments `school_demographics` and
#'   `work_demographics` with `conmat_original_school_demographics` and `conmat_original_work_demographics`, respectively.
#' @examples
#' age_min <- 10
#' age_max <- 15
#' all_ages <- age_min:age_max
#' library(tidyr)
#' example_df <- expand_grid(
#'   age_from = all_ages,
#'   age_to = all_ages,
#' )
#'
#' example_df %>%
#'   add_population_age_to() %>%
#'   add_school_work_participation()
#'
#' example_df %>%
#'   add_population_age_to() %>%
#'   add_school_work_participation(
#'     school_demographics = conmat_original_school_demographics,
#'     work_demographics = conmat_original_work_demographics
#'   )
#' @export
add_school_work_participation <- function(contact_data,
                                          school_demographics = NULL,
                                          work_demographics = NULL) {
  contact_data %>%
    add_school_fraction(school_demographics) %>%
    add_school_probability() %>%
    add_work_fraction(work_demographics) %>%
    add_work_probability()
}

add_work_fraction <- function(contact_data, work_demographics = NULL) {
  # user can provide their own work demographic data, however by default
  # we will use averaged data from the ABS.
  if (is.null(work_demographics)) {
    work_demographics <- abs_avg_work
  }

  # check is has the right kind of data structure
  check_work_demographics(work_demographics)

  # add work fraction data to both age_from and age_to
  contact_data %>%
    dplyr::left_join(
      work_demographics,
      dplyr::join_by(age_from == age)
    ) %>%
    dplyr::rename(
      work_fraction_age_from = work_fraction
    ) %>%
    dplyr::left_join(
      work_demographics,
      dplyr::join_by(age_to == age)
    ) %>%
    dplyr::rename(
      work_fraction_age_to = work_fraction
    )
}

add_school_fraction <- function(contact_data, school_demographics = NULL) {
  # user can provide their own school demographic data, however by default
  # we will use averaged data from the ABS.
  if (is.null(school_demographics)) {
    school_demographics <- abs_avg_school
  }

  # check is has the right kind of data structure
  check_school_demographics(school_demographics)

  # add work fraction data to both age_from and age_to
  contact_data %>%
    dplyr::left_join(
      school_demographics,
      dplyr::join_by(age_from == age)
    ) %>%
    dplyr::rename(
      school_fraction_age_from = school_fraction
    ) %>%
    dplyr::left_join(
      school_demographics,
      dplyr::join_by(age_to == age)
    ) %>%
    dplyr::rename(
      school_fraction_age_to = school_fraction
    )
}

add_school_probability <- function(contact_data) {
  contact_data %>%
    dplyr::mutate(
      # the probability that a person of the other age other party goes to the
      # same school/work. May not be the same place. But proportional to the
      # increase in contacts due to attendance. So this helps
      school_probability = school_fraction_age_from * school_fraction_age_to,
      # the probability that a person of the other age would be in the same
      # school year
      # So, if ages are the same, we get (2 - 0) / 4 = 0.5
      # if ages are one year apart we get (2 - 1) / 4 = 0.25
      # if ages are 2 years apart or higher, we get (2 - 2) / 4 = 0
      # so to adjust for the fraction of people who are in the same school year
      # but might be different ages.
      # If they're the same age, they have a 50% chance of being in the same
      # year
      # if they're one year apart, they have a 25% chance of being in the same year
      # note - might change this to be an if else or case when
      school_year_probability = school_probability * (2 - pmin(2, abs(age_from - age_to))) / 4,
      # a weighted combination of this and the population age distribution, so
      # that if the contact is in the same school year, the weight is 1, and
      # otherwise it is the population age fraction. this can be used as an
      # offset, so that population age distribution can be used outside the
      # classroom, but does not affect classroom contacts (which due to
      # cohorting and regularised class sizes are unlikely to depend on the
      # population age distribution)
      school_weighted_pop_fraction = pop_age_to * (1 - school_year_probability) + 1 * school_year_probability
    )
}

add_work_probability <- function(contact_data) {
  contact_data %>%
    dplyr::mutate(
      work_probability = work_fraction_age_from * work_fraction_age_to
    )
}
