% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predictions_to_matrix.R
\name{predictions_to_matrix}
\alias{predictions_to_matrix}
\title{Convert dataframe of predicted contacts into matrix}
\usage{
predictions_to_matrix(contact_predictions, ...)
}
\arguments{
\item{contact_predictions}{data frame with columns \code{age_group_from},
\code{age_group_to}, and \code{contacts}.}

\item{...}{extra arguments}
}
\value{
Square matrix with the unique age groups from \code{age_group_from/to}
in the rows and columns and \code{contacts} as the values.
}
\description{
Helper function to convert predictions of contact rates in data
frames to matrix format with the survey participant age groups as columns
and contact age groups as rows.
}
\examples{
fairfield <- abs_age_lga("Fairfield (C)")

# We can convert the predictions into a matrix

fairfield_school_contacts <- predict_contacts(
  model = polymod_setting_models$school,
  population = fairfield,
  age_breaks = c(0, 5, 10, 15, Inf)
)

fairfield_school_contacts

# convert them back to a matrix
predictions_to_matrix(fairfield_school_contacts)

}
