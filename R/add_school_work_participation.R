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
#' @return dataset with 9 extra columns: school_fraction_age_from,
#'   work_fraction_age_from, school_fraction_age_to, work_fraction_age_to,
#'   school_probability, work_probability, school_year_probability, and
#'   school_weighted_pop_fraction.
#' @note this uses fake data that will get replaced with abs data input soon
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
#' @export
add_school_work_participation <- function(contact_data) {
  contact_data %>%
    dplyr::mutate(
      # ok so this could perhaps instead be the "default" action
      # and the alternative could be to pass some data that has a class in
      # it that contains school and work data and also names of the
      # columns that contain the relevant information.
      # so as a first pass we can leave it as is
      # and then we can develop an approach with polymod
      # or perhaps have ABS as another default
      # so the overall outcome is either that you provide this data
      # or we provide some assumptions
      dplyr::across(
        c("age_from", "age_to"),
        .fns = list(
          # made up example - replace with education statistics
          school_fraction = ~ dplyr::case_when(
            # preschool
            .x %in% 2:4 ~ 0.5,
            # compulsory education
            .x %in% 5:16 ~ 1,
            # voluntary education
            .x %in% 17:18 ~ 0.5,
            # university
            .x %in% 19:25 ~ 0.1,
            # other
            TRUE ~ 0.05
          ),
          # made up example - replace with labour force statistics
          work_fraction = ~ dplyr::case_when(
            # child labour
            .x %in% 12:19 ~ 0.2,
            # young adults (not at school)
            .x %in% 20:24 ~ 0.7,
            # main workforce
            .x %in% 25:60 ~ 1,
            # possibly retired
            .x %in% 61:65 ~ 0.7,
            # other
            TRUE ~ 0.05
          )
        ),
        .names = "{.fn}_{.col}"
      ),
      # the probability that a person of the other age other party goes to the
      # same school/work. May not be the same place. But proportional to the
      # increase in contacts due to attendance. So this helps
      school_probability = school_fraction_age_from * school_fraction_age_to,
      work_probability = work_fraction_age_from * work_fraction_age_to,
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
