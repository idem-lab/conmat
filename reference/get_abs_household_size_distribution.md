# Get household size distribution based on state or LGA name

Get household size distribution based on state or LGA name

## Usage

``` r
get_abs_household_size_distribution(state = NULL, lga = NULL)
```

## Arguments

- state:

  target Australian state name in abbreviated form, such as "QLD",
  "NSW", or "TAS"

- lga:

  target Australian local government area (LGA) name, such as "Fairfield
  (C)". See
  [`abs_lga_lookup()`](https://idem-lab.github.io/conmat/reference/abs_lga_lookup.md)
  for list of lga names

## Value

returns a data frame with household size distributions of a specific
state or LGA

## Examples

``` r
get_abs_household_size_distribution(lga = "Fairfield (C)")
#> # A tibble: 8 × 5
#> # Groups:   lga [1]
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
get_abs_household_size_distribution(state = "NSW")
#> # A tibble: 1,048 × 5
#> # Groups:   state [1]
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
# cannot specify both state and LGA - errrors
try(get_abs_household_size_distribution(state = "NSW", lga = "Fairfield (C)"))
#> Error in get_abs_household_size_distribution(state = "NSW", lga = "Fairfield (C)") : 
#>   only one of state and lga may be specified
```
