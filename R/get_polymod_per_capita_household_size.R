#' @title get polymod per capita houshold size
#' 
#' Convenience function to help get the per capita household size. This is
#'     calculated as `mean(socialmixr::polymod$participants$hh_size)`.
#' 
#' @return number, 3.248971
#' @author Nicholas Tierney
#' @export
get_polymod_per_capita_household_size <- function() {
    mean(socialmixr::polymod$participants$hh_size)
}