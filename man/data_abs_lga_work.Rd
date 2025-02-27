% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_abs_lga_work.R
\docType{data}
\name{data_abs_lga_work}
\alias{data_abs_lga_work}
\title{LGA wise ABS work population data on different ages for year 2016}
\format{
A data frame with 64,496 rows and 8 variables:
\describe{
\item{year}{2016, as data is from 2016 Census of Population and Housing.}
\item{state}{String denoting the abbreviated name of state or territory
name such as 'NSW', 'VIC', 'QLD' etc.}
\item{lga}{String denoting the official name of Local Government Area.
For example, 'Albury (C).'}
\item{age}{Ages from 0 to 115.}
\item{employed_population}{Number of people employed including people
with full-time, part-time employment status.}
\item{total_population}{Total population of age in row.}
\item{proportion}{The ratio of employed population and total population
belonging to the age i.e, employed_population/ total_population.}
\item{anomaly_flag}{Logical variable flagging abnormal observations, such
as total population lesser than employed_population as TRUE.}
}
}
\source{
{Census of Population and Housing, 2016, TableBuilder}
}
\usage{
data_abs_lga_work
}
\description{
A dataset containing Australian Bureau of Statistics labour force population
data by lga for 2016. The data sourced from 2016 Census - Employment,
Income and Education through TableBuilder have been randomly adjusted by
the ABS to avoid the release of confidential data. As a result of this,
there are some cases where the estimated number of people being employed
is higher than the population of those people. Such cases have been
flagged under the \code{anomaly_flag} variable.
}
\keyword{datasets}
