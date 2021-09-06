# return the polymod-average population age distribution in 5y
# increments (weight country population distributions by number of participants)
# note that we don't want to weight by survey age distributions for this, since
# the total number of *participants* represents the sampling
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
#' @seealso 
#'  \code{\link[dplyr]{filter}},\code{\link[dplyr]{group_by}},\code{\link[dplyr]{summarise}},\code{\link[dplyr]{context}},\code{\link[dplyr]{mutate-joins}}
#'  \code{\link[socialmixr]{wpp_age}}
#'  \code{\link[stats]{weighted.mean}}
#' @rdname get_polymod_population
#' @export 
#' @importFrom dplyr filter group_by summarise n left_join
#' @importFrom socialmixr wpp_age
#' @importFrom stats weighted.mean
get_polymod_population <- function() {
  
  polymod$participants %>%
    dplyr::filter(
      !is.na(year)
    ) %>%
    dplyr::group_by(
      country,
      year
    ) %>%
    dplyr::summarise(
      participants = dplyr::n(),
      .groups = "drop"
    ) %>%
    dplyr::left_join(
      socialmixr::wpp_age(),
      by = c("country", "year")
    ) %>%
    dplyr::filter(
      !is.na(lower.age.limit)
    ) %>%
    dplyr::group_by(
      lower.age.limit
    ) %>%
    dplyr::summarise(
      population = stats::weighted.mean(population, participants)
    )
  
}
