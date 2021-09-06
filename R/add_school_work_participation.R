# add fractions of the population in each age group that attend school/work
# (average FTE), to compute the probability that both participant and contact
# attend school/work
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param contact_data PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[dplyr]{mutate}},\code{\link[dplyr]{across}},\code{\link[dplyr]{reexports}},\code{\link[dplyr]{case_when}}
#' @rdname add_school_work_participation
#' @export 
#' @importFrom dplyr mutate across starts_with case_when
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
      # the probabilities that both parties go to school/work. May not be the same
      # place. But proportional to the increase in contacts due to attendance
      school_probability = school_fraction_age_from * school_fraction_age_to,
      work_probability = work_fraction_age_from * work_fraction_age_to,
    )
}
