#' Get polymod setting data

#' @return polymod data
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # EXAMPLE1
#' }
#' }
#' @export
get_polymod_setting_data <- function() {
  list(
    home = get_polymod_contact_data("home"),
    work = get_polymod_contact_data("work"),
    school = get_polymod_contact_data("school"),
    other = get_polymod_contact_data("other")
  )
}
