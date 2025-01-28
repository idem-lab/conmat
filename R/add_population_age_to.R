#' Add the population distribution for contact ages.
#'
#' Adds the population distribution of contact ages. Requires a column called
#'   "age_to", representing the contact age - the age of the person who had
#'   contact. It creates a column, `pop_age_to`. The `population` argument
#'   defaults to [get_polymod_population()], which is a `conmat_population`
#'   object, which has `age` and `population` specified. But this can also be
#'   a data frame with columns, `lower.age.limit`, and `population`. If
#'   population is 'polymod' then use the participant-weighted average of
#'   POLYMOD country/year distributions. It adds the population via
#'   interpolation, using [get_age_population_function()] to create a
#'   function that generates population from ages.
#'
#' @param contact_data contact data containing columns `age_to` and `age_from`
#' @param population Defaults to [get_polymod_population()], a
#'  `conmat_population` object, which specifies the `age` and `population`
#'  columns. But it can optionally be any data frame with columns,
#'  `lower.age.limit`, and `population`.
#' @return data frame of `contact_data` with the number of intergenerational
#' mixing contacts added.
#' @examples
#' age_min <- 10
#' age_max <- 15
#' all_ages <- age_min:age_max
#' library(tidyr)
#' example_df <- expand_grid(
#'   age_from = all_ages,
#'   age_to = all_ages,
#' )
#' add_population_age_to(example_df)
#' @export
add_population_age_to <- function(contact_data,
                                  population = get_polymod_population()) {
  # get function to interpolate population age distributions to 1y bins
  age_population_function <- get_age_population_function(population)

  # add the population in each 'to' age for the survey context
  contact_data %>%
    # add interpolated population to "age_to"
    dplyr::mutate(
      pop_age_to = age_population_function(age_to)
    ) %>%
    dplyr::group_by(age_from) %>%
    # normalise to get a relative population
    dplyr::mutate(
      pop_age_to = pop_age_to / sum(pop_age_to)
    ) %>%
    dplyr::ungroup() %>%
    add_intergenerational()
}
