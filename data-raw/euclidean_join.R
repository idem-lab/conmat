#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param matrix_vals_prob_1y
#' @return
#' @author Nick Golding
#' @export
euclidean_join <- function (.data,
                            legend,
                            by = intersect(names(.data), names(legend))) {
  # Do Euclidean lookup from matrix pixels to legends
  
  # get Euclidean distance matrix between data and legend
  distances <- rdist(
    .data[, by],
    legend[, by]
  )
  
  # find the index to the nearest value in the legend
  row_idx <- apply(distances, 1, which.min)
  
  # get the new columns from the legend
  by_col_idx <- match(by, names(legend))
  new_cols <- legend[, -by_col_idx]
  
  # combine them
  bind_cols(
    .data,
    new_cols[row_idx, ]
  )
  
}
