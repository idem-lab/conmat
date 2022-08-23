#' Extract out formula terms
#'
#' @param model model object
#'
#' @name formula-terms
#' @examples
#' \dontrun{
#' formula_terms <- get_formulas_terms(sim_m)
#' formula_terms
#' }

get_formulas_terms <- function(model){
  as.character(attr(terms(model$formula), "variables"))[-c(1,2)]
}

# extract_term_name(formula_terms)
extract_term_name <- function(x){
  term <- as.character(stringr::str_extract_all(x, "(?<=\\().+?(?=\\))"))
  glue::glue("fitted_{term}")
}

# head(predict_gam_term(sim_m, sim_data, formula_terms[1]))
# tail(predict_gam_term(sim_m, sim_data, formula_terms[1]))
predict_gam_term <- function(model, data, terms){
  
  c(
    predict(model,
            data, 
            type = "terms", 
            terms = terms)
  )
  
}

add_intercept <- function(data, model){
  dplyr::mutate(
    .data = data,
    fitted_intercept = model$coefficients[1]
  )
}

tidy_predict_term <- function(data,
                              model,
                              term){
  
  term_name <- extract_term_name(term)
  
  dat_term <- tibble::tibble(x = predict_gam_term(model, data, term))
  
  setNames(dat_term, term_name)
  
}

add_fitted_overall <- function(data){
  data %>% 
    dplyr::mutate(
      fitted_overall = rowSums(
        dplyr::across(
          .cols = c(tidyselect::starts_with("fitted"))
          )
        )
    )
}

add_gam_predictions <- function(data, model, term) {
  terms <- get_formulas_terms(model)
  predictions <- purrr::map_dfc(
    .x = terms,
    .f = tidy_predict_term,
    data = data,
    model = model
  )
  
  data %>% 
    add_intercept(model) %>% 
    dplyr::bind_cols(predictions) %>% 
    add_fitted_overall()
  
}