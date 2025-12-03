# Coerce object to a setting prediction matrix

This will also calculate an `all` matrix, if `all` is not specified.
This is the sum of all other matrices.

## Usage

``` r
as_setting_prediction_matrix(list_matrix, age_breaks, ...)
```

## Arguments

- list_matrix:

  list of matrices

- age_breaks:

  numeric vector of ages

- ...:

  extra arguments (currently not used)

## Value

object of class setting prediction matrix

## Examples

``` r
age_breaks_0_80_plus <- c(seq(0, 80, by = 10), Inf)
one_by_nine <- matrix(1, nrow = 9, ncol = 9)

mat_list <- list(
  home = one_by_nine,
  work = one_by_nine
)

mat_list
#> $home
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9]
#>  [1,]    1    1    1    1    1    1    1    1    1
#>  [2,]    1    1    1    1    1    1    1    1    1
#>  [3,]    1    1    1    1    1    1    1    1    1
#>  [4,]    1    1    1    1    1    1    1    1    1
#>  [5,]    1    1    1    1    1    1    1    1    1
#>  [6,]    1    1    1    1    1    1    1    1    1
#>  [7,]    1    1    1    1    1    1    1    1    1
#>  [8,]    1    1    1    1    1    1    1    1    1
#>  [9,]    1    1    1    1    1    1    1    1    1
#> 
#> $work
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9]
#>  [1,]    1    1    1    1    1    1    1    1    1
#>  [2,]    1    1    1    1    1    1    1    1    1
#>  [3,]    1    1    1    1    1    1    1    1    1
#>  [4,]    1    1    1    1    1    1    1    1    1
#>  [5,]    1    1    1    1    1    1    1    1    1
#>  [6,]    1    1    1    1    1    1    1    1    1
#>  [7,]    1    1    1    1    1    1    1    1    1
#>  [8,]    1    1    1    1    1    1    1    1    1
#>  [9,]    1    1    1    1    1    1    1    1    1
#> 

mat_set <- as_setting_prediction_matrix(
  mat_list,
  age_breaks = age_breaks_0_80_plus
)

mat_set
#> 
#> ── Setting Prediction Matrices ─────────────────────────────────────────────────
#> 
#> A list of matrices containing the model predicted contact rate between ages in
#> each setting.
#> 
#> There are 9 age breaks, ranging 0-80+ years, with a regular 10 year interval
#> 
#> • home: a 9x9 <matrix>
#> • work: a 9x9 <matrix>
#> • all: a 9x9 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$home`
```
