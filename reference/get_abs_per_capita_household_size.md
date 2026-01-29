# Get per capita household size based on state or LGA name

Get per capita household size based on state or LGA name

## Usage

``` r
get_abs_per_capita_household_size(state = NULL, lga = NULL)
```

## Arguments

- state:

  state name

- lga:

  lga name

## Value

Numeric of length 1 - the per capita household size for a given state or
LGA.

## Author

Nick Golding

## Examples

``` r
get_abs_per_capita_household_size(lga = "Fairfield (C)")
#> [1] 4.199372
get_abs_per_capita_household_size(state = "NSW")
#> [1] 3.4407
# cannot specify both state and LGA - this will error
try(get_abs_per_capita_household_size(state = "NSW", lga = "Fairfield (C)"))
#> Error in get_abs_per_capita_household_size(state = "NSW", lga = "Fairfield (C)") : 
#>   only one of state and lga may be specified
```
