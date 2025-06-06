% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_abs_household_lga.R
\docType{data}
\name{abs_household_lga}
\alias{abs_household_lga}
\title{ABS household data for 2016}
\format{
A data frame with 4986 rows and 6 variables:
\describe{
\item{year}{year - 2016}
\item{state}{state - long state or territory name}
\item{lga}{name of LGA}
\item{n_persons_usually_resident}{Number of people typically in residence}
\item{n_households}{number of households with that number of people}
}
}
\source{
\url{https://www.abs.gov.au/statistics}
(downloaded the CSV) PEOPLE > People and Communities > Household Composition > Census 2016, T23 Household Composition By Number Of Persons Usually Resident (LGA)
}
\usage{
abs_household_lga
}
\description{
A dataset containing Australian Bureau of Statistics household
data for 2016. The data is filtered to "Total Households". Contains
information on the number of people typically in a residence in the region
and the number of households associated with those number of residents.
This data is typically used to obtain the household size distributions to
compute the per capita household size of a particular region.
}
\note{
still need to clean this
}
\keyword{datasets}
