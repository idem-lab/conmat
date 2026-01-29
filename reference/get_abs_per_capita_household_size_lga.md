# Get household size distribution based on LGA name

Get household size distribution based on LGA name

## Usage

``` r
get_abs_per_capita_household_size_lga(lga = NULL)
```

## Arguments

- lga:

  target Australian local government area (LGA) name, such as "Fairfield
  (C)". See
  [`abs_lga_lookup()`](https://idem-lab.github.io/conmat/reference/abs_lga_lookup.md)
  for list of lga names

## Value

returns a numeric value depicting the per capita household size of the
specified LGA

## Examples

``` r
get_abs_per_capita_household_size_lga(lga = "Fairfield (C)")
#> [1] 4.199372
```
