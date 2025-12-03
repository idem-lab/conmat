# Get population associated with each household size in an LGA or a state

Get population associated with each household size in an LGA or a state

## Usage

``` r
get_abs_household_size_population(state = NULL, lga = NULL)
```

## Arguments

- state:

  target Australian state name in abbreviated form, such as "QLD",
  "NSW", or "TAS"

- lga:

  target Australian local government area (LGA) name, such as "Fairfield
  (C)". See
  [`abs_lga_lookup()`](https://idem-lab.github.io/conmat/dev/reference/abs_lga_lookup.md)
  for list of lga names

## Value

returns a data frame with household size and the population associated
with it in each LGA or state.

## Examples

``` r
get_abs_household_size_population(state = "NSW")
#> # A tibble: 1,048 × 5
#>     year state lga                   household_size n_people
#>    <dbl> <chr> <chr>                          <dbl>    <dbl>
#>  1  2016 NSW   Albury (C)                         1     6020
#>  2  2016 NSW   Albury (C)                         2    13476
#>  3  2016 NSW   Albury (C)                         3     8220
#>  4  2016 NSW   Albury (C)                         4    10164
#>  5  2016 NSW   Albury (C)                         5     5205
#>  6  2016 NSW   Albury (C)                         6     1866
#>  7  2016 NSW   Albury (C)                         7      392
#>  8  2016 NSW   Albury (C)                         8      336
#>  9  2016 NSW   Armidale Regional (A)              1     2983
#> 10  2016 NSW   Armidale Regional (A)              2     7326
#> # ℹ 1,038 more rows
```
