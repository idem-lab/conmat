#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param age_breaks
#' @param age_breaks_1y
#' @return
#' @author Nick Golding
#' @export
get_age_group_lookup <- function(
  age_breaks,
  age_breaks_1y = 0:100,
  label_includes_upper = FALSE
) {
  
  n_breaks <- length(age_breaks)
  age_group_lookup <- expand.grid(
    age = age_breaks_1y,
    index = seq_len(n_breaks - 1)
  ) %>%
    mutate(
      lower = age_breaks[index],
      upper = age_breaks[index + 1]
    ) %>%
    filter(
      age >= lower & age < upper
    ) %>%
    mutate(
      label_includes_upper = label_includes_upper,
      upper = ifelse(label_includes_upper, upper, upper - 1),
      upper = paste0("-", upper),
      upper = if_else(upper == "-Inf", "+", upper),
      age_group = paste0(lower, upper)
    ) %>%
    select(
      age,
      age_group
    )
}
