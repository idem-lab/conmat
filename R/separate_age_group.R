
# take the data frame and column name for the age variable 
# separate age group into "lower.age.limit" & "upper.age.limit"

separate_age_group <- function(.data, age_col) {
  return(
    .data %>%
      tidyr::separate(
        {{ age_col }}, 
        c("lower.age.limit", "upper.age.limit"), "[[:punct:]]", extra = "merge") %>%
      dplyr::mutate(
        lower.age.limit = readr::parse_number(as.character(.data$lower.age.limit)),
        upper.age.limit = readr::parse_number(as.character(.data$upper.age.limit))
      )%>%
      tibble::as_tibble()
  )
}
