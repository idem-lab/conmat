#' ABS household data for 2016
#'
#' A dataset containing Australian Bureau of Statistics household data for 2016.
#'   The data is filtered to "Total Households".
#'
#' @format A data frame with 4986 rows and 6 variables:
#' \describe{
#'   \item{year}{year - 2020}
#'   \item{state}{state - long state or territory name}
#'   \item{lga}{name of LGA}
#'   \item{household_composition}{as recorded in data - either Male or Female}
#'   \item{n_persons_usually_resident}{Number of people typically in residence}
#'   \item{n_households}{number of households with that number of people}
#' }
#' @note still need to clean this
#' @source  \url{https://stat.data.abs.gov.au/Index.aspx?Datasetcode=ABS_FAMILY_PROJ}
#' (downloaded the CSV) PEOPLE > People and Communities > Household Composition > Census 2016, T23 Household Composition By Number Of Persons Usually Resident (LGA)
"abs_household_lga"
