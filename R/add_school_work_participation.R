#' Add fractions of the population in each age group that attend school/work
#' (average FTE)
#'
#' Add fractions of the population in each age group that attend school/work
#'   (average FTE) to compute the probability that both participant and
#'   contact attend school/work.
#' @param contact_data contact data
#' @return dataset
#' @note this is fake data that will get replaced with abs data soon
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
add_school_work_participation <- function(contact_data) {
  contact_data %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("age"),
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
