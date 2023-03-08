add_new_class <- function(x, new_class) {
  class(x) <- c(new_class, class(x))
  x
}

#' Build new age matrix
#'
#' A matrix that knows about its age breaks - which are by default provided as
#'   its rownames. Mostly intended for internal use.
#'
#' @param matrix numeric matrix
#' @param age_breaks character vector of age breaks, by default the rownames.
#'
#' @return matrix with age breaks attribute
#'
#' @examples
#' age_break_names <- c("[0,5)", "[5,10)", "[10, 15)")
#' age_mat <- matrix(
#'   runif(9),
#'   nrow = 3,
#'   ncol = 3,
#'   dimnames = list(
#'     age_break_names,
#'     age_break_names
#'   )
#' )
#'
#' new_age_matrix(
#'   age_mat,
#'   age_breaks = age_break_names
#' )
#'
#' @export
new_age_matrix <- function(matrix, age_breaks) {
  structure(
    matrix,
    age_breaks = age_breaks,
    class = c("conmat_age_matrix", class(matrix))
  )
}

#' Extract age break attribute information
#'
#' @param x an object containing age break information
#'
#' @return age breaks character vector
#' @examples
#' age_breaks <- c(0, 5, 19, 15)
#' age_break_names <- c("[0,5)", "[5,10)", "[10, 15)")
#' age_mat <- matrix(
#'   runif(9),
#'   nrow = 3,
#'   ncol = 3,
#'   dimnames = list(
#'     age_break_names,
#'     age_break_names
#'   )
#' )
#'
#' age_mat <- new_age_matrix(age_mat, age_breaks)
#'
#' age_breaks(age_mat)
#' @export
age_breaks <- function(x) {
  UseMethod("age_breaks")
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.conmat_age_matrix <- function(x) {
  attr(x, "age_breaks")
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.conmat_setting_prediction_matrix <- function(x) {
  attr(x, "age_breaks")
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.setting_data <- function(x) {
  attr(x, "age_breaks")
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.ngm_setting_matrix <- function(x) {
  attr(x, "age_breaks")
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.setting_vaccination_matrix <- function(x) {
  attr(x, "age_breaks")
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.numeric <- function(x) {
  x
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.matrix <- function(x) {
  cli::cli_abort(
    "no method for {.code age_breaks()} defined for object of class {.cls {class(x)}} yet"
  )
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.array <- function(x) {
  cli::cli_abort(
    "no method for {.code age_breaks()} defined for object of class {.cls {class(x)}} yet"
  )
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.predicted_contacts <- function(x) {
  attr(x, "age_breaks")
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.transmission_probability_matrix <- function(x) {
  attr(x, "age_breaks")
}

#' @describeIn age_breaks Get age break information
#' @export
age_breaks.default <- function(x) {
  cli::cli_abort(
    "no method for {.code age_breaks()} defined for object of class {.cls {class(x)}} yet"
  )
}

new_setting_data <- function(list_df) {
  structure(
    list_df,
    age_breaks = unique(list_df$home$age_from),
    class = c("setting_data", class(list_df))
  )
}

new_ngm_setting_matrix <- function(list_matrix,
                                   raw_eigenvalue,
                                   scaling,
                                   age_breaks) {
  structure(
    list_matrix,
    raw_eigenvalue = raw_eigenvalue,
    scaling = scaling,
    age_breaks = age_breaks,
    class = c("ngm_setting_matrix", class(list_matrix))
  )
}


#' Get raw eigvenvalue from NGM matrix
#'
#' @param list_matrix object of class `ngm_setting_matrix`
#'
#' @return raw eigenvalue
#'
#' @examples
#' # examples not run as they take a long time
#' \dontrun{
#' perth <- abs_age_lga("Perth (C)")
#' perth_contact <- extrapolate_polymod(perth)
#' perth_ngm <- generate_ngm(
#'   perth_contact,
#'   age_breaks = c(seq(0, 85, by = 5), Inf)
#' )
#' raw_eigenvalue(perth_ngm)
#' }
#' @export
raw_eigenvalue <- function(list_matrix) {
  attr(list_matrix, "raw_eigenvalue")
}

#' Get the scaling from NGM matrix
#'
#' This value is `scaling <- R_target / R_raw`, where `R_target` is the target
#'   R value provided to the NGM, and `R_raw` is the raw eigenvalue.
#'
#' @param list_matrix object of class `ngm_setting_matrix`
#'
#' @return scaling
#'
#' @examples
#' # examples not run as they take a long time
#' \dontrun{
#' perth <- abs_age_lga("Perth (C)")
#' perth_contact <- extrapolate_polymod(perth)
#' perth_ngm <- generate_ngm(
#'   perth_contact,
#'   age_breaks = c(seq(0, 85, by = 5), Inf)
#' )
#' raw_eigenvalue(perth_ngm)
#' scaling(perth_ngm)
#' }
#' @export
scaling <- function(list_matrix) {
  attr(list_matrix, "scaling")
}

new_setting_contact_model <- function(list_model) {
  add_new_class(list_model, "setting_contact_model")
}

new_setting_vaccination_matrix <- function(list_matrix,
                                           age_breaks) {
  structure(
    list_matrix,
    age_breaks = age_breaks,
    class = c("setting_vaccination_matrix", class(list_matrix))
  )
}

new_predicted_contacts <- function(df, age_breaks) {
  tibble::new_tibble(
    x = df,
    age_breaks = age_breaks,
    class = "predicted_contacts"
  )
}
