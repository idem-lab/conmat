#' @title Adjust Household Contact Matrix
#' @param setting_matrices
#' @param household_size
#' @return
#' @author Nick Golding
#' @export
adjust_household_contact_matrix <- function(setting_matrices,
                                            household_size,
                                            population,
                                            household_contact_rate = 1,
                                            model_mean_other_householders = 2.248971) {
  
  # get the mean number of other household members from thpolymod data used to
  # train the contact model
  
  # model_mean_other_householders <- socialmixr::polymod$participants %>%
  #   mutate(
  #     other_householders = hh_size - 1
  #   ) %>%
  #   summarise(
  #     mean(other_householders)
  #   )
  
  # given a list of 4 setting-specific synthetic contact matrices (including
  # 'home'), and a mean household size, adjust the number of household contacts
  # to match the average household size in that LGA from ABS, accounting for the
  # fact that household contacts are proportional to (but not the same as) the
  # number of other household members
  
  # get ratio between expected number of other household members (household size
  # minus 1) for this place from ABS data, and the average from the data used to
  # train the model
  expected_other_householders <- household_contact_rate * (household_size - 1)
  ratio <- expected_other_householders / model_mean_other_householders
  
  # adjust home matrix and recompute all matrix
  settings <- setdiff(names(setting_matrices), "all")
  setting_matrices$home <- setting_matrices$home * ratio
  setting_matrices$all <- Reduce('+', setting_matrices[settings])
  
  setting_matrices
  
}
