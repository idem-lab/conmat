# 2020 ABS education population data, interpolated into 1 year bins, by state.

A dataset containing Australian Bureau of Statistics education data by
state for 2020. These were interpolated into 1 year age bins. There are
still some issued with the methods used, as the interpolated values are
sometimes higher than the population.

## Usage

``` r
abs_education_state_2020
```

## Format

A data frame with 808 rows and 6 variables:

- year:

  year - 2020

- state:

  state - short state or territory name

- age:

  0 to 100

- population:

  number of people full and part time

- population_interpolated:

  "Government" or "Non-government"

- prop:

  population / population_interpolated

## Source

<https://www.abs.gov.au/statistics/people/education/schools/2020#data-download>
(table 42B)
