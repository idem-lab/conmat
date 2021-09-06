# return an interpolating function to get populations in 1y age increments from
# chunkier distributions produced by socialmixr::wpp_age() (must contain `lower.age.limit` and `population`)
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param population PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[dplyr]{arrange}}
#'  \code{\link[stats]{splinefun}}
#' @rdname get_age_population_function
#' @export 
#' @importFrom dplyr arrange
#' @importFrom stats splinefun spline
get_age_population_function <- function(population) {
  
  population <- population %>%
    dplyr::arrange(lower.age.limit)
  
  # compute the widths of age bins
  bin_widths <- diff(population$lower.age.limit)
  final_bin_width <- bin_widths[length(bin_widths)]
  bin_widths <- c(bin_widths, final_bin_width)
  
  # range of ages (assume the final bin width is that same as the previous one,
  # since we cannot extrapolate the infinite upper bound without known the upper
  # age limit)
  min_age <- min(population$lower.age.limit)
  max_age <- max(population$lower.age.limit) + final_bin_width
  
  # interpolator to 1y age groups up to 100
  spline <- stats::splinefun(
    x = population$lower.age.limit,
    y = population$population / bin_widths, 
  )
  
  # wrap this up in a function to handle values outside this range
  function(age) {
    population <- stats::spline(age)
    invalid <- age < min(age) | age > max_age
    population[invalid] <- 0
    pmax(population, 0)
  }
  
}
