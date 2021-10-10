#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param lower.age.limit
#' @return
#' @author Nick Golding
#' @export
bin_widths <- function(lower_bound) {

  # return the widths of bins denoted by a sequence of lower bounds (assumming
  # the final is the same as the [penultimate])
  diffs <- diff(lower_bound)
  c(diffs, diffs[length(diffs)])
  
}
