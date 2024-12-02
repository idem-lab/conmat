#' Contact matrices as calculated by Prem. et al.
#'
#' Contact matrices as calculated by Prem. et al. (2021) PLoS Computational Biology. Updated to use the latest corrected matrices from their 2021 publication.
#' DOI: 10.1371/journal.pcbi.1009098
#'
#' @format A list with 5 elements:
#' \describe{
#'   \item{home}{A 16x16 matrix containing the number of home contacts, by 5
#'   year age group}
#'   \item{work}{A 16x16 matrix containing the number of workplace contacts, by
#'  5 year age group}
#'   \item{school}{A 16x16 matrix containing the number of school contacts, by 5
#'   year age group}
#'   \item{other}{A 16x16 matrix containing the number of other contacts, by 5
#'   year age group}
#'   \item{all}{A 16x16 matrix containing the number of all contacts, by 5
#'   year age group}
#' }
#' All age groups are 5 year age bands, from 0 to 80.
#'
#' @source \url{https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1009098}
#' @source \url{https://github.com/kieshaprem/synthetic-contact-matrices}
"prem_germany_contact_matrices"
