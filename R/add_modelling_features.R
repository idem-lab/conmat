#' Add features required for modelling to the dataset
#'
#' @param contact_data contact data
#' @param ... extra dots
#' @return data frame
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @note internal
#' @export
add_modelling_features <- function(contact_data, ...) {
  
  # use interpolated population of "age_to" (contact age) & 
  # get the relative population grouped by "age_from" or participant age
  # add new variables for : school & work going fraction for contact & participant ages
  #                       : probability that a person of the other age goes to the same  work/school 
  #                       : probability that a person of the other age would be in the same school year
  #                       : weighted combination of contact population & school year probability. 
  #                       [ for using outside of classroom?]
  # offset for school setting & the rest. 
   contact_data %>%
    add_population_age_to(...) %>%
    add_school_work_participation() %>%
    add_offset()
}
