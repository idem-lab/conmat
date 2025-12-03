# Get the scaling from NGM matrix

This value is `scaling <- R_target / R_raw`, where `R_target` is the
target R value provided to the NGM, and `R_raw` is the raw eigenvalue.

## Usage

``` r
scaling(list_matrix)
```

## Arguments

- list_matrix:

  object of class `ngm_setting_matrix`

## Value

scaling

## Examples

``` r
# examples not run as they take a long time
# \donttest{
perth <- abs_age_lga("Perth (C)")
perth_contact <- extrapolate_polymod(perth)
perth_ngm <- generate_ngm(
  perth_contact,
  age_breaks = c(seq(0, 85, by = 5), Inf)
)
#> Error in check_age_breaks(x = age_breaks(x), y = age_breaks, x_arg = "x",     y_arg = "age_breaks"): Age breaks must be the same, but they are different:
#>          `x[14:17]`: 65 70 75 Inf       
#> `age_breaks[14:19]`: 65 70 75  80 85 Inf
#> ℹ You can check the age breaks using `age_breaks(<object>)`
raw_eigenvalue(perth_ngm)
#> Error: object 'perth_ngm' not found
scaling(perth_ngm)
#> Error: object 'perth_ngm' not found
# }
```
