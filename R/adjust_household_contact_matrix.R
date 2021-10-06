#' @title Adjust Household Contact Matrix
#' 
#' This function is used internally within [predict_setting_contacts()].
#' See details below for why we use the per capita adjustment
#' 
#' @details We use Per-capita household size instead of mean household size.
#'     Per-capita household size is different to mean household size, as the 
#'     household size averaged over people in the **population**, not over 
#'     households, so larger households get upweighted. It is calculated by 
#'     taking a distribution of the number of households of each size in a 
#'     population, multiplying the size by the household by the household count 
#'     to get the number of people with that size of household, and computing 
#'     the population-weighted average of household sizes. We use per-capita 
#'     household size as it is a more accurate reflection of the average 
#'     number of household members a person in the population can have contact 
#'     with.
#'
#' @param setting_matrices setting matrix
#' @param per_capita_household_size single number of the size of a household
#' @param model_per_capita_household_size per capita household size
#'
#' @return contact matrix that has household adjustment
#' @author Nick Golding
#' @export
adjust_household_contact_matrix <- function(setting_matrices,
                                            per_capita_household_size,
                                            model_per_capita_household_size) {
  
  # given a list of 4 setting-specific synthetic contact matrices (including
  # 'home'), and a mean household size, adjust the number of household contacts
  # to match the average household size in that LGA from ABS, accounting for the
  # fact that household contacts are proportional to (but not the same as) the
  # number of other household members
  
  # get ratio between expected number of other household members (household size
  # minus 1) for this place from ABS data, and the average from the data used to
  # train the model
  ratio <- (per_capita_household_size - 1) / (model_per_capita_household_size - 1)
  
  # adjust home matrix and recompute all matrix
  settings <- setdiff(names(setting_matrices), "all")
  setting_matrices$home <- setting_matrices$home * ratio
  setting_matrices$all <- Reduce('+', setting_matrices[settings])
  
  setting_matrices
  
}
