#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION

#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname get_polymod_setting_data
#' @export 
get_polymod_setting_data <- function() {
  list(
    home = get_polymod_contact_data("home"),
    work = get_polymod_contact_data("work"),
    school = get_polymod_contact_data("school"),
    other = get_polymod_contact_data("other")
  )
}
