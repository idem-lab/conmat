#' Polymod Settings models
#' 
#' A data object containing a list of fitted gam models predicting the number of contacts in each of the four 
#'   settings which are "home","work","school" and "other". For more details on model fitting, see [fit_setting_contacts()]
#' 
#' @seealso [fit_setting_contacts()]
#' @examples 
#' \dontrun{
#' library(conmat)
#' polymod_contact_data <- get_polymod_setting_data()
#' polymod_survey_data <- get_polymod_population()
#'polymod_setting_models <- fit_setting_contacts(
#'  contact_data_list = polymod_contact_data,
# population = polymod_survey_data
#')
#' }
#' 
#' 
#'
#' 
"polymod_setting_models"
