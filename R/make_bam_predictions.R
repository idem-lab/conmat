#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author njtierney
#' @export
make_bam_predictions <- function(x) {

  x %>% 
  # add on prediction features, setting the population to predict to
  add_modelling_features(
    population = population
  ) %>%
    dplyr::mutate(
      # prediction
      contacts = mgcv::predict.bam(
        model,
        newdata = .,
        type = "response"
      ),
      # uncertainty
      se_contacts = mgcv::predict.bam(
        model,
        newdata = .,
        type = "response",
        se.fit = TRUE
      )$se.fit
    ) %>%
    dplyr::select(
      age_from,
      age_to,
      contacts,
      se_contacts
    )

}
