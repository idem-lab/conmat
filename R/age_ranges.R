#' @title
#' @param ages vector of ages
#' @noRd
#' @return vector length 1 of min and max ages used in calculating age
#' @author njtierney
age_ranges <- function(ages) {

  min_age <- min(ages)
  bin_widths <- diff(ages)
  final_bin_width <- bin_widths[length(bin_widths)]
  age_max_integration <- max(ages) + final_bin_width
  
  c(min_age, age_max_integration)

}