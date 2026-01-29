# Get polymod per capita household size.

Convenience function to help get the per capita household size. This is
calculated as `mean(socialmixr::polymod$participants$hh_size)`.

## Usage

``` r
get_polymod_per_capita_household_size()
```

## Value

number, 3.248971

## Author

Nicholas Tierney

## Examples

``` r
get_polymod_per_capita_household_size()
#> [1] 3.248971
```
