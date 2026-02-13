# taken from predict_contacts_1y
#' @export
predict_contacts_flexible <- function(
  model,
  population,
  age_vector
) {

  # predict contacts to all given years
  tidyr::expand_grid(
    age_from = age_vector,
    age_to = age_vector,
  ) %>%
    make_bam_predictions()
 
}
