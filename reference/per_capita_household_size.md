# Get per capita household size with household size distribution

Returns the per capita household size for a location given its household
size distribution. See
[`get_abs_household_size_distribution()`](https://idem-lab.github.io/conmat/reference/get_abs_household_size_distribution.md)
function for retrieving household size distributions for a given place.

## Usage

``` r
per_capita_household_size(
  household_data,
  household_size_col = household_size,
  n_people_col = n_people
)
```

## Arguments

- household_data:

  data set with information on the household size distribution of
  specific state or LGA.

- household_size_col:

  bare variable name of the column depicting the household size. Default
  is 'household_size' from
  [`get_abs_per_capita_household_size_lga()`](https://idem-lab.github.io/conmat/reference/get_abs_per_capita_household_size_lga.md).

- n_people_col:

  bare variable name of the column depicting the total number of people
  belonging to the respective household size. Default is 'n_people' from
  [`get_abs_per_capita_household_size_lga()`](https://idem-lab.github.io/conmat/reference/get_abs_per_capita_household_size_lga.md).

## Value

Numeric of length 1 - the per capita household size for a given state or
LGA.

## Author

Nick Golding

## Examples

``` r
demo_data <- get_abs_household_size_population(lga = "Fairfield (C)")
demo_data
#> # A tibble: 8 × 5
#>    year state lga           household_size n_people
#>   <dbl> <chr> <chr>                  <dbl>    <dbl>
#> 1  2016 NSW   Fairfield (C)              1     9002
#> 2  2016 NSW   Fairfield (C)              2    26776
#> 3  2016 NSW   Fairfield (C)              3    31599
#> 4  2016 NSW   Fairfield (C)              4    44676
#> 5  2016 NSW   Fairfield (C)              5    33890
#> 6  2016 NSW   Fairfield (C)              6    21216
#> 7  2016 NSW   Fairfield (C)              7     9800
#> 8  2016 NSW   Fairfield (C)              8    10976
per_capita_household_size(
  household_data = demo_data,
  household_size_col = household_size,
  n_people_col = n_people
)
#> [1] 4.199372
```
