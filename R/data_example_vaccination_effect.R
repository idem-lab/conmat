#' @title Example dataset with information on age based vaccination coverage,
#'   acquisition and transmission
#'
#' @description data frame with information on vaccine coverage, efficacy of
#'    acquisition/susceptibility and efficacy of transmission/infectiousness
#'    for the ordered age groups from lowest to highest of the next generation
#'    matrix.
#'    
#' @format A data frame with 17 rows and 4 variables
#' \describe{
#'   \item{age_band}{character. age bands: 0-4,5-11, 12-15, 16-19, 20-24, etc}
#'   \item{coverage}{example vaccination coverage, between 0-1}
#'   \item{acquisition}{example acquisition coverage, between 0-1}
#'   \item{transmission}{example transmission coverage, between 0-1}
#' }
#'
"vaccination_effect_example_data"