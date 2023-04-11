#' Original school demographics for conmat
#'
#' An internal dataset containing the original estimates of which fraction of
#'   ages were attending school in Australia. These can be used inside of
#'   [fit_single_contact_model()] and [fit_setting_contacts()].
#'
#' @format A data frame with 121 rows and 2 variables:
#' \describe{
#'   \item{age}{0 to 120}
#'   \item{school_fraction}{fraction of population at school}
#' }
#' @source {Census of Population and Housing, 2016, TableBuilder}
"conmat_original_school_demographics"

#' Original work demographics for conmat
#'
#' An internal dataset containing the original estimates of which fraction of
#'   ages were working in Australia. These can be used inside of
#'   [fit_single_contact_model()] and [fit_setting_contacts()].
#'
#' @format A data frame with 121 rows and 2 variables:
#' \describe{
#'   \item{age}{0 to 120}
#'   \item{work_fraction}{fraction of population working.}
#' }
#' @source {Census of Population and Housing, 2016, TableBuilder}
"conmat_original_work_demographics"
