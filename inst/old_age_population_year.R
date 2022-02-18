
age_population_year <- function(data, age_col, year_col, year) {
  age_var <- dplyr::pull(data, {{ age_col }})
  .args <- as.list(match.call()[-1])
  
  
  if (is.numeric(age_var)) {
    label <- c(paste(seq(0, 84, by = 5),
                     seq(0 + 5 - 1, 85 - 1, by = 5),
                     sep = "-"
    ), paste(85, 120, sep = "-"))
    
    data <- data %>%
      dplyr::mutate(age_group = cut({{ age_col }},
                                    breaks = c(seq(0, 85, by = 5), Inf),
                                    labels = label, right = FALSE
      ))
    cleaned_df <- separate_age_group(data, age_group) %>% dplyr::filter({{ year_col }} == {{ year }})
    return(cleaned_df)
  } else {
    cleaned_df <- separate_age_group(data, {{age_col}}) %>% dplyr::filter({{ year_col }} == {{ year }})
    return(cleaned_df)
  }
}