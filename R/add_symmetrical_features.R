#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author njtierney
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
