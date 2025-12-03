# Get household size distribution based on state name

Get household size distribution based on state name

## Usage

``` r
get_abs_per_capita_household_size_state(state = NULL)
```

## Arguments

- state:

  target Australian state name in abbreviated form, such as "QLD",
  "NSW", or "TAS"

## Value

returns a numeric value depicting the per capita household size of the
specified state

## Examples

``` r
get_abs_per_capita_household_size_state(state = "NSW")
#> [1] 3.4407
```
