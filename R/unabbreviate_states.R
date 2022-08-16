#' Un-abbreviate Australian state names
#'
#' @param state_names vector of state names in short form
#'
#' @return Longer state names
#' @export
#'
#' @examples
#' abbreviate_states("VIC")
unabbreviate_states <- function(state_names) {
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
