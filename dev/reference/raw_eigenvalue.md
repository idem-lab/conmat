# Get raw eigvenvalue from NGM matrix

Get raw eigvenvalue from NGM matrix

## Usage

``` r
raw_eigenvalue(list_matrix)
```

## Arguments

- list_matrix:

  object of class `ngm_setting_matrix`

## Value

raw eigenvalue

## Examples

``` r
perth <- abs_age_lga("Perth (C)")
perth_contact <- extrapolate_polymod(perth)
perth_contact
#> 
#> ── Setting Prediction Matrices ─────────────────────────────────────────────────
#> 
#> A list of matrices containing the model predicted contact rate between ages in
#> each setting.
#> 
#> There are 16 age breaks, ranging 0-75+ years, with a regular 5 year interval
#> 
#> • home: a 16x16 <matrix>
#> • work: a 16x16 <matrix>
#> • school: a 16x16 <matrix>
#> • other: a 16x16 <matrix>
#> • all: a 16x16 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`
# must be the same age breaks as in perth_contact - 0-75
perth_ngm <- generate_ngm(
  perth_contact,
  age_breaks = c(seq(0, 75, by = 5), Inf),
  R_target = 1.5
)
raw_eigenvalue(perth_ngm)
#> [1] 3.469723
```
