# Add symmetrical, age based features

This function adds 6 columns to assist with describing various age based
interactions for model fitting. Requires that the age columns are called
"age_from", and "age_to"

## Usage

``` r
add_symmetrical_features(data)
```

## Arguments

- data:

  data.frame with columns, `age_from`, and `age_to`

## Value

data.frame with 6 more columns, `gam_age_offdiag`, `gam_age_offdiag_2`,
`gam_age_diag_prod`, `gam_age_diag_sum`, `gam_age_pmax`, `gam_age_pmin`,

## Examples

``` r
vec_age <- 0:2
dat_age <- expand.grid(
  age_from = vec_age,
  age_to = vec_age
)

add_symmetrical_features(dat_age)
#>   age_from age_to gam_age_offdiag gam_age_offdiag_2 gam_age_diag_prod
#> 1        0      0               0                 0                 0
#> 2        1      0               1                 1                 0
#> 3        2      0               2                 4                 0
#> 4        0      1               1                 1                 0
#> 5        1      1               0                 0                 1
#> 6        2      1               1                 1                 2
#> 7        0      2               2                 4                 0
#> 8        1      2               1                 1                 2
#> 9        2      2               0                 0                 4
#>   gam_age_diag_sum gam_age_pmax gam_age_pmin
#> 1                0            0            0
#> 2                1            1            0
#> 3                2            2            0
#> 4                1            1            0
#> 5                2            1            1
#> 6                3            2            1
#> 7                2            2            0
#> 8                3            2            1
#> 9                4            2            2
```
