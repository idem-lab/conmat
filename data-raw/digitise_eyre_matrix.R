#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param matrix_file
#' @param age_breaks
#' @return
#' @author Nick Golding
#' @export
digitise_eyre_matrix <- function(
  matrix_file,
  legend_file = "data-raw/eyre_legend_raw.png",
  matrix_age_range = c(4.5, 70.5),
  legend_probability_range = c(0.16, 0.8),
  age_breaks = seq(0, 100)
) {
  
  # load the rasters
  matrix <- png::readPNG(matrix_file)[, , 1:3]
  legend <- png::readPNG(legend_file)[, , 1:3]
  
  # bounds of the age matrix
  n_contact_pixels <- dim(matrix)[1]
  n_case_pixels <- dim(matrix)[2]
  min_age <- min(matrix_age_range)
  max_age <- max(matrix_age_range)
  
  # ages for intereger-year summary and aggregation
  age_breaks_1y <- 0:100
  max_age_aggregate <- max(age_breaks)
  
  # convert legend into 3 channel lookup
  legend_vals <- legend[75, , ] %>%
    `colnames<-`(c("R", "G", "B")) %>%
    as_tibble() %>%
    mutate(
      probability = seq(
        min(legend_probability_range),
        max(legend_probability_range),
        length.out = n()
      )
    )
  
  # convert matrix into tibble with age labels
  case_ages <- seq(min_age, max_age, length.out = n_case_pixels)
  contact_ages <- seq(min_age, max_age, length.out = n_contact_pixels)
  matrix_vals <- matrix %>%
    `dim<-`(c(n_contact_pixels * n_case_pixels, 3)) %>%
    `colnames<-`(c("R", "G", "B")) %>%
    as_tibble() %>%
    mutate(
      case_age = rep(case_ages, each = n_contact_pixels),
      contact_age = rep(rev(contact_ages), n_case_pixels),
      .before = everything()
    )
  
  # interpolate linearly from colours to probabilities, based on the legend
  mod <- lm(probability ~ R + G + B,
            data = legend_vals)
  
  matrix_vals_prob <- matrix_vals %>%
    mutate(
      probability = predict(
        object = mod,
        newdata = .)
    )
  
  # aggregate to 1y resolution
  matrix_vals_prob_1y <- matrix_vals_prob %>%
    mutate(
      across(
        ends_with("age"),
        round
      )
    ) %>%
    group_by(
      case_age, contact_age
    ) %>%
    summarise(
      across(
        probability,
        mean
      ),
      .groups = "drop"
    )
  
  # extrapolate to all ages, filling in the value for the nearest age pair
  matrix_vals_prob_1y_all <- expand_grid(
    case_age = age_breaks_1y,
    contact_age = age_breaks_1y,
  ) %>%
    euclidean_join(
      matrix_vals_prob_1y
    )
  
  # optionally aggregate up to the specified age breaks
  if (identical(age_breaks, age_breaks_1y)) {
    
    matrix_vals_prob_agg <- matrix_vals_prob_1y_all
    
  } else {
    
    age_group_lookup <- get_age_group_lookup(
      age_breaks,
      age_breaks_1y
    )
    
    matrix_vals_prob_agg <- matrix_vals_prob_1y_all %>%
      left_join(
        age_group_lookup,
        by = c(case_age = "age")
      ) %>%
      select(
        -case_age
      ) %>%
      rename(
        case_age = age_group, 
      ) %>%
      left_join(
        age_group_lookup,
        by = c(contact_age = "age")
      ) %>%
      select(
        -contact_age
      ) %>%
      rename(
        contact_age = age_group
      ) %>%
      relocate(
        ends_with("age"),
        .before = "probability"
      ) %>%
      mutate(
        across(
          ends_with("age"),
          ~ factor(.x,
                   levels = str_sort(
                     unique(.x),
                     numeric = TRUE
                   )
          )
        )
      ) %>%
      group_by(
        case_age,
        contact_age
      ) %>%
      summarise(
        across(
          probability,
          mean
        ),
        .groups = "drop"
      )
    
  }
  
  matrix_vals_prob_agg
  
}