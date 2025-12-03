# ABS household data for 2016

A dataset containing Australian Bureau of Statistics household data for
2016. The data is filtered to "Total Households". Contains information
on the number of people typically in a residence in the region and the
number of households associated with those number of residents. This
data is typically used to obtain the household size distributions to
compute the per capita household size of a particular region.

## Usage

``` r
abs_household_lga
```

## Format

A data frame with 4986 rows and 6 variables:

- year:

  year - 2016

- state:

  state - long state or territory name

- lga:

  name of LGA

- n_persons_usually_resident:

  Number of people typically in residence

- n_households:

  number of households with that number of people

## Source

<https://www.abs.gov.au/statistics> (downloaded the CSV) PEOPLE \>
People and Communities \> Household Composition \> Census 2016, T23
Household Composition By Number Of Persons Usually Resident (LGA)

## Note

still need to clean this
