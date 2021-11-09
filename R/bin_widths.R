#' @title return the widths of bins denoted by a sequence of lower bounds
#' @description  return the widths of bins denoted by a sequence of lower 
#'   bounds (assumming the final is the same as the `[penultimate]`).
#' @param lower_bound lower bound value - a numeric vector
#' @return vector
#' @author Nick Golding
#' @export
bin_widths <- function(lower_bound) {

  # return the widths of bins denoted by a sequence of lower bounds (assumming
  # the final is the same as the [penultimate])
  diffs <- diff(lower_bound)
  c(diffs, diffs[length(diffs)])
  
}
