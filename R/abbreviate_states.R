#' Abbreviate Australian State Names
#'
#' Given a full name (Title Case) of an Australian State or Territory, produces
#'   the abbreviated state name.
#'
#' @param state_names vector of state names in long form
#'
#' @return shortened state names
#'
#' @seealso [abs_unabbreviate_states()]
#' @examples
#' abs_abbreviate_states("Victoria")
#' abs_abbreviate_states(c("Victoria", "Queensland"))
#' @export
abs_abbreviate_states <- function(state_names) {
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

#' Un-abbreviate Australian state names
#'
#' @param state_names vector of state names in short form
#'
#' @return Longer state names
#' @seealso [abs_abbreviate_states()]
#'
#' @examples
#' abs_unabbreviate_states("VIC")
#' abs_unabbreviate_states(c("VIC", "QLD"))
#' @export
abs_unabbreviate_states <- function(state_names) {
  dplyr::case_when(
    state_names %in% c("Australian Capital Territory", "ACT") ~ "Australian Capital Territory",
    state_names %in% c("New South Wales", "NSW") ~ "New South Wales",
    state_names %in% c("Northern Territory", "NT") ~ "Northern Territory",
    state_names %in% c("Queensland", "QLD") ~ "Queensland",
    state_names %in% c("South Australia", "SA") ~ "South Australia",
    state_names %in% c("Tasmania", "TAS") ~ "Tasmania",
    state_names %in% c("Victoria", "VIC") ~ "Victoria",
    state_names %in% c("Western Australia", "WA") ~ "Western Australia"
  )
}
