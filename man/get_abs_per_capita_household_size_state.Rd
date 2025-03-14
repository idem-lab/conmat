% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/abs_per_capita_household_size_state.R
\name{get_abs_per_capita_household_size_state}
\alias{get_abs_per_capita_household_size_state}
\title{Get household size distribution based on state name}
\usage{
get_abs_per_capita_household_size_state(state = NULL)
}
\arguments{
\item{state}{target Australian state name in abbreviated form, such as "QLD", "NSW", or "TAS"}
}
\value{
returns a numeric value depicting the per capita household size of the specified state
}
\description{
Get household size distribution based on state name
}
\examples{
get_abs_per_capita_household_size_state(state = "NSW")
}
