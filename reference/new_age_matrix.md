# Build new age matrix

A matrix that knows about its age breaks - which are by default provided
as its rownames. Mostly intended for internal use.

## Usage

``` r
new_age_matrix(matrix, age_breaks)
```

## Arguments

- matrix:

  numeric matrix

- age_breaks:

  character vector of age breaks, by default the rownames.

## Value

matrix with age breaks attribute

## Examples

``` r
age_break_names <- c("[0,5)", "[5,10)", "[10, 15)")
age_mat <- matrix(
  runif(9),
  nrow = 3,
  ncol = 3,
  dimnames = list(
    age_break_names,
    age_break_names
  )
)

new_age_matrix(
  age_mat,
  age_breaks = age_break_names
)
#>              [0,5)     [5,10)  [10, 15)
#> [0,5)    0.1467177 0.84755333 0.5445798
#> [5,10)   0.7890640 0.29821366 0.3321896
#> [10, 15) 0.3335275 0.01687886 0.6517686
```
