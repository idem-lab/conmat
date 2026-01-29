# Create a setting transmission matrix

Helper function to create your own setting transmission matrix, which
you may want to use in ... or `autoplot`. This class is the output of
functions like `...`, and ... . We recommend using this function is only
for advanced users, who are creating their own transmission probability
matrix.

## Usage

``` r
transmission_probability_matrix(..., age_breaks)
```

## Arguments

- ...:

  list of matrices

- age_breaks:

  age breaks - numeric

## Value

transmission probability matrix

## Examples

``` r
age_breaks_0_80_plus <- c(seq(0, 80, by = 10), Inf)
one_05 <- matrix(0.05, nrow = 9, ncol = 9)

x_example <- transmission_probability_matrix(
  home = one_05,
  work = one_05,
  age_breaks = age_breaks_0_80_plus
)

x_example <- transmission_probability_matrix(
  one_05,
  one_05,
  age_breaks = age_breaks_0_80_plus
)

x_example
#> 
#> ── Transmission Probability Matrices ───────────────────────────────────────────
#> 
#> A list of matrices, each <matrix> containing the relative probability of
#> individuals in a given age group infecting an individual in another age group,
#> for that setting.
#> 
#> There are 9 age breaks, ranging 0-80+ years, with a regular 10 year interval
#> 
#> • one: a 9x9 <matrix>
#> • two: a 9x9 <matrix>
#> ℹ Access each <matrix> with `x$name`
#> ℹ e.g., `x$one`
```
