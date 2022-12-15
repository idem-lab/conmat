#' @title Add symmetrical, age based features
#' @description This function adds 6 columns to assist with describing
#'   various age based interactions for model fitting. Requires that the
#'   age columns are called "age_from", and "age_to"
#' 
#' @param data data.frame with columns, `age_from`, and `age_to`
#' @return data.frame with 6 more columns, `gam_age_offdiag`, `gam_age_offdiag_2`, `gam_age_diag_prod`, `gam_age_diag_sum`, `gam_age_pmax`, `gam_age_pmin`,
#' @examples
#' vec_age <- 0:2
#' dat_age <- expand.grid(
#'   age_from = vec_age,
#'   age_to = vec_age
#' )
#' 
#' add_symmetrical_features(dat_age)
#' 
#' @export
add_symmetrical_features <- function(data) {
  # add terms back into the data frame
  data %>% 
    dplyr::mutate(
      gam_age_offdiag = abs(age_from - age_to),
      gam_age_offdiag_2 = abs(age_from - age_to)^2,
      gam_age_diag_prod = abs(age_from * age_to),
      gam_age_diag_sum = abs(age_from + age_to),
      gam_age_pmax = pmax(age_from, age_to),
      gam_age_pmin = pmin(age_from, age_to)
    )

}

# gam(
#   response ~
#     s(I(abs(age_from - age_to))) +
#     s(I(abs(age_from - age_to)^2)) +
#     s(I(abs(age_from * age_to))) +
#     s(I(abs(age_from + age_to))) +
#     s(I(pmax(age_from, age_to))) +
#     s(I(pmin(age_from, age_to))),
#   family = poisson,
#   offset = log(participants),
#   data = data
# )
