% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/setting-prediction-matrix.R
\name{as_setting_prediction_matrix}
\alias{as_setting_prediction_matrix}
\title{Coerce object to a setting prediction matrix}
\usage{
as_setting_prediction_matrix(list_matrix, age_breaks, ...)
}
\arguments{
\item{list_matrix}{list of matrices}

\item{age_breaks}{numeric vector of ages}

\item{...}{extra arguments (currently not used)}
}
\value{
object of class setting prediction matrix
}
\description{
This will also calculate an \code{all} matrix, if \code{all} is not specified.  This
is the sum of all other matrices.
}
\examples{

age_breaks_0_80_plus <- c(seq(0, 80, by = 10), Inf)
one_by_nine <- matrix(1, nrow = 9, ncol = 9)

mat_list <- list(
  home = one_by_nine,
  work = one_by_nine
)

mat_list

mat_set <- as_setting_prediction_matrix(
  mat_list,
  age_breaks = age_breaks_0_80_plus
)

mat_set

}
