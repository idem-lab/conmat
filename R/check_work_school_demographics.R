#' @title Check Work Demographics
#' @param work_demographics work data
#' @keywords internal
#' @author njtierney
check_work_demographics <- function(work_demographics) {
  work_names <- c("age", "work_fraction")
  names_correct <- all(work_names %in% names(work_demographics))
  if (!names_correct) {
    cli::format_error(
      c(
        "work demographic data must be named {.var {work_names}}",
        "we see: {.var {names(work_demographics)}}"
      )
    )
  }

  vctrs::vec_assert(work_demographics$work_fraction, numeric())

  is_proportion <- all(dplyr::between(work_demographics$work_fraction, 0, 1))

  if (!is_proportion) {
    cli::format_error(
      c(
        "{.var work_fraction} must be between 0 and 1, however the range is:",
        "{range(work_demographics$work_fraction)}"
      )
    )
  }
}

#' @title Check School Demographics
#' @param school_demographics school data
#' @keywords internal
#' @author njtierney
check_school_demographics <- function(school_demographics) {
  school_names <- c("age", "school_fraction")
  names_correct <- all(school_names %in% names(school_demographics))
  if (!names_correct) {
    cli::format_error(
      c(
        "school demographic data must be named {.var {school_names}}",
        "we see: {.var {names(school_demographics)}}"
      )
    )
  }

  vctrs::vec_assert(school_demographics$school_fraction, numeric())

  is_proportion <- all(dplyr::between(school_demographics$school_fraction, 0, 1))

  if (!is_proportion) {
    cli::format_error(
      c(
        "{.var school_fraction} must be between 0 and 1, however the range is:",
        "{range(school_demographics$school_fraction)}"
      )
    )
  }
}
