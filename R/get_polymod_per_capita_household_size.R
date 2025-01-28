#' @title Get polymod per capita household size.
#'
#' @description Convenience function to help get the per capita household size.
#'   This is calculated as `mean(socialmixr::polymod$participants$hh_size)`.
#'
#' @return number, 3.248971
#' @author Nicholas Tierney
#' @examples
#' get_polymod_per_capita_household_size()
#' @export
get_polymod_per_capita_household_size <- function() {
  mean(socialmixr::polymod$participants$hh_size)
}
