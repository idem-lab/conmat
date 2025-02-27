#' Get polymod setting data
#'
#' `get_polymod_setting_data()` acts as an extension of
#'   `get_polymod_contact_data()`, and extracts the setting wise contact data
#'   on the desired country, as a list.

#' @param countries countries to extract data from
#' @return A list of data frames, of the polymod data. One list per setting:
#'   "home", "work", "school", and "other".
#' @examples
#' get_polymod_setting_data()
#' get_polymod_setting_data("Belgium")
#' @export
get_polymod_setting_data <- function(
  countries = c(
    "Belgium",
    "Finland",
    "Germany",
    "Italy",
    "Luxembourg",
    "Netherlands",
    "Poland",
    "United Kingdom"
  )
) {
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
  ) %>%
    new_setting_data()
}
