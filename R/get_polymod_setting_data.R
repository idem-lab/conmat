#' Get polymod setting data

#' @param countries countries to extract data from
#' @return polymod data
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
get_polymod_setting_data <- function(countries = c("Belgium", "Finland", "Germany", "Italy", "Luxembourg", "Netherlands", 
                                                   "Poland", "United Kingdom")) {
  list(
    home = get_polymod_contact_data(
      setting = "home",
      countries = countries
    ),
    work = get_polymod_contact_data(
      setting = "work",
      countries = countries
    ),
    school = get_polymod_contact_data(
      setting = "school",
      countries = countries
    ),
    other = get_polymod_contact_data(
      setting = "other",
      countries = countries
    )
  )
}
