# Return data on employed population for a given age and state or lga of Australia

Return data on employed population for a given age and state or lga of
Australia

## Usage

``` r
abs_age_work_lga(lga = NULL, age = NULL)

abs_age_work_state(state = NULL, age = NULL)
```

## Arguments

- lga:

  target Australian local government area (LGA) name, such as "Fairfield
  (C)" or a vector with multiple lga names. See
  [`abs_lga_lookup()`](https://idem-lab.github.io/conmat/reference/abs_lga_lookup.md)
  for list of lga names.

- age:

  a numeric or numeric vector denoting ages between 0 to 115. The
  default is to return all ages.

- state:

  target Australian state name or a vector with multiple state names in
  its abbreviated form, such as "QLD", "NSW", or "TAS"

## Value

data set with information on the number of employed people belonging to
a particular age, its total population and the corresponding proportion.

## Examples

``` r
abs_age_work_state(state = "NSW")
#> # A tibble: 116 × 6
#>     year state   age employed_population total_population proportion
#>    <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
#>  1  2016 NSW       0                   0            87708          0
#>  2  2016 NSW       1                   0            92876          0
#>  3  2016 NSW       2                   0            93584          0
#>  4  2016 NSW       3                   0            95179          0
#>  5  2016 NSW       4                   0            95791          0
#>  6  2016 NSW       5                   0            95216          0
#>  7  2016 NSW       6                   0            96479          0
#>  8  2016 NSW       7                   0            95142          0
#>  9  2016 NSW       8                   0            95833          0
#> 10  2016 NSW       9                   0            95516          0
#> # ℹ 106 more rows
abs_age_work_state(state = c("QLD", "TAS"), age = 5)
#> # A tibble: 2 × 6
#>    year state   age employed_population total_population proportion
#>   <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
#> 1  2016 QLD       5                   0            61981          0
#> 2  2016 TAS       5                   0             6132          0
abs_age_work_lga(lga = "Albany (C)", age = 1:5)
#> # A tibble: 5 × 8
#>    year state lga          age employed_population total_population proportion
#>   <dbl> <chr> <chr>      <dbl>               <dbl>            <dbl>      <dbl>
#> 1  2016 WA    Albany (C)     1                   0              348          0
#> 2  2016 WA    Albany (C)     2                   0              413          0
#> 3  2016 WA    Albany (C)     3                   0              434          0
#> 4  2016 WA    Albany (C)     4                   0              418          0
#> 5  2016 WA    Albany (C)     5                   0              376          0
#> # ℹ 1 more variable: anomaly_flag <lgl>
abs_age_work_lga(lga = c("Albury (C)", "Barcoo (S)"), age = 39)
#> # A tibble: 2 × 8
#>    year state lga          age employed_population total_population proportion
#>   <dbl> <chr> <chr>      <dbl>               <dbl>            <dbl>      <dbl>
#> 1  2016 NSW   Albury (C)    39                 434              587      0.739
#> 2  2016 QLD   Barcoo (S)    39                   5                4      1.25 
#> # ℹ 1 more variable: anomaly_flag <lgl>
```
