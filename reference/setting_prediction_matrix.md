# Create a setting prediction matrix

Helper function to create your own setting prediction matrix, which you
may want to use in `generate_ngm`, or `autoplot`. This class is the
output of functions like `extrapolate_polymod`, and
`predict_setting_contacts`. We recommend using this function is only for
advanced users, who are creating their own setting prediction matrix.

## Usage

``` r
setting_prediction_matrix(..., age_breaks)
```

## Arguments

- ...:

  list of matrices

- age_breaks:

  age breaks - numeric

## Value

setting prediction matrix

## Examples

``` r
age_breaks_0_80_plus <- c(seq(0, 80, by = 10), Inf)
one_by_nine <- matrix(1, nrow = 9, ncol = 9)

x_example <- setting_prediction_matrix(
  home = one_by_nine,
  work = one_by_nine,
  age_breaks = age_breaks_0_80_plus
)

x_example <- setting_prediction_matrix(
  one_by_nine,
  one_by_nine,
  age_breaks = age_breaks_0_80_plus
)

x_example
#> 
#> ── Setting Prediction Matrices ─────────────────────────────────────────────────
#> 
#> A list of matrices containing the model predicted contact rate between ages in
#> each setting.
#> 
#> There are 9 age breaks, ranging 0-80+ years, with a regular 10 year interval
#> 
#> • one: a 9x9 <matrix>
#> • two: a 9x9 <matrix>
#> • all: a 9x9 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$one`
```
