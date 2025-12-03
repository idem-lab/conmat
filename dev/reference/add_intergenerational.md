# Add column, "intergenerational"

For modelling purposes it is useful to have a feature that is the
absolute difference between `age_from` and `age_to` columns.

## Usage

``` r
add_intergenerational(data)
```

## Arguments

- data:

  data.frame with columns `age_from`, and `age_to`

## Value

data.frame with extra column, `intergenerational`

## Examples

``` r
polymod_contact <- get_polymod_contact_data()

polymod_contact %>% add_intergenerational()
#> # A tibble: 8,787 × 6
#>    setting age_from age_to contacts participants intergenerational
#>    <chr>      <int>  <dbl>    <int>        <int>             <dbl>
#>  1 all            0      0       31           92                 0
#>  2 all            0      1       11           92                 1
#>  3 all            0      2       26           92                 2
#>  4 all            0      3       23           92                 3
#>  5 all            0      4       14           92                 4
#>  6 all            0      5       13           92                 5
#>  7 all            0      6       12           92                 6
#>  8 all            0      7       11           92                 7
#>  9 all            0      8        7           92                 8
#> 10 all            0      9        8           92                 9
#> # ℹ 8,777 more rows
```
