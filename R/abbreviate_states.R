#' Abbreviate Australian State Names
#'
#' Given a full name (Title Case) of an Australian State or Territory, produces
#'   the abbreviated state name.
#'
#' @param state_names vector of state names in long form
#'
#' @return shortened state names
#'
#' @seealso [unabbreviate_states()]
#' @examples
#' abbreviate_states("Victoria")
#' abbreviate_states(c("Victoria", "Queensland"))
#' @export
abbreviate_states <- function(state_names) {
  dplyr::case_when(
    state_names %in% c("Australian Capital Territory", "ACT") ~ "ACT",
    state_names %in% c("New South Wales", "NSW") ~ "NSW",
    state_names %in% c("Northern Territory", "NT") ~ "NT",
    state_names %in% c("Queensland", "QLD") ~ "QLD",
    state_names %in% c("South Australia", "SA") ~ "SA",
    state_names %in% c("Tasmania", "TAS") ~ "TAS",
    state_names %in% c("Victoria", "VIC") ~ "VIC",
    state_names %in% c("Western Australia", "WA") ~ "WA"
  )
}
