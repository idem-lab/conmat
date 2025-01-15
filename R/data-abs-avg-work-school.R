#' ABS work data for 2016
#'
#' An internal dataset containing Australian Bureau of Statistics work data for
#'   each age in 2016. The data is averaged across each state to provide an
#'   overall average, and is used to provide estimated work populations for
#'   model fitting in [add_school_work_participation()], which is used in [fit_single_contact_model()]. The data is summarised from `data_abs_state_work`,
#'   see `?data_abs_state_work` for more details.
#'
#' @format A data frame with 116 rows and 2 variables:
#' \describe{
#'   \item{age}{0 to 115}
#'   \item{work_fraction}{fraction of population working.}
#' }
#' @source {Census of Population and Housing, 2016, TableBuilder}
"abs_avg_work"

#' ABS education data for 2016
#'
#' An internal dataset containing Australian Bureau of Statistics education data for
#'   each age in 2016. The data is averaged across each state to provide an
#'   overall average, and is used to provide estimated education populations for
#'   model fitting in [add_school_work_participation()], which is used in [fit_single_contact_model()]. The data is summarised from `data_abs_state_education`,
#'   see `?data_abs_state_education` for more details.
#'
#' @format A data frame with 116 rows and 2 variables:
#' \describe{
#'   \item{age}{0 to 115}
#'   \item{school_fraction}{fraction of population at school}
#' }
#' @source {Census of Population and Housing, 2016, TableBuilder}
"abs_avg_school"
