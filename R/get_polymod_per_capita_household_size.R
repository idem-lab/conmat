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
  # get the mean number of other household members from thpolymod data used to
  # train the contact model
  
  # model_mean_other_householders <- socialmixr::polymod$participants %>%
  #   mutate(
  #     other_householders = hh_size - 1
  #   ) %>%
  #   summarise(
  #     mean(other_householders)
  #   )
  
}