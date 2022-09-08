#' @title Convert a contact matrix as output into a long-form tibble
#' 
#' @description This function is the opposite of [predictions_to_matrix()]. It
#'   converts a wide matrix into a long data frame. It is mostly used within 
#'   plotting functions.
#'
#' @param contact_matrix square matrix with age group to and from information
#'   in the row and column names.
#'   
#' @return data.frame with columns `age_group_to`, `age_group_from`, and
#'   `contacts`.
#'   
#' @examples
#'  fairfield_abs_data <- abs_age_lga("Fairfield (C)")
#'  
#'  # We can convert the predictions into a matrix
#'    
#'  fairfield_school_contacts <- predict_contacts(
#'    model = polymod_setting_models$school,
#'    population = fairfield_abs_data,
#'    age_breaks = c(0, 5, 10, 15,Inf)
#'  )
#'  
#'  fairfield_school_contacts
#'  
#'  fairfield_school_mat <- predictions_to_matrix(fairfield_school_contacts)
#'  
#'  fairfield_school_mat
#'  
#'  matrix_to_predictions(fairfield_school_mat)
#' @export
matrix_to_predictions <- function(contact_matrix) {
  contact_matrix %>%
    tibble::as_tibble(
      rownames = "age_group_to"
    ) %>%
    tidyr::pivot_longer(
      cols = -c(age_group_to),
      names_to = "age_group_from",
      values_to = "contacts"
    ) %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("age_group"),
        ~ factor(.x, levels = unique(.x))
      )
    )
}
