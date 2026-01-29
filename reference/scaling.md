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
  age_breaks = c(seq(0, 75, by = 5), Inf),
  R_target = 1.5
)
raw_eigenvalue(perth_ngm)
#> [1] 3.469723
scaling(perth_ngm)
#> [1] 0.4323112
# }
```
