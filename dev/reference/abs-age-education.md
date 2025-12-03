# Return data on educated population for a given age and state or lga of Australia.

Return data on educated population for a given age and state or lga of
Australia.

## Usage

``` r
abs_age_education_state(state = NULL, age = NULL)

abs_age_education_lga(lga = NULL, age = NULL)
```

## Arguments

- state:

  target Australian state name or a vector with multiple state names in
  its abbreviated form, such as "QLD", "NSW", or "TAS"

- age:

  a numeric or numeric vector denoting ages between 0 to 115. The
  default is to return all ages.

- lga:

  target Australian local government area (LGA) name, such as "Fairfield
  (C)" or a vector with multiple lga names. See
  [`abs_lga_lookup()`](https://idem-lab.github.io/conmat/dev/reference/abs_lga_lookup.md)
  for list of lga names.

## Value

dataset with information on the number of educated people belonging to a
particular age, its total population and the corresponding proportion.

## Examples

``` r
abs_age_education_state(state = "VIC")
#> # A tibble: 116 × 6
#>     year state   age population_educated total_population proportion
#>    <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
#>  1  2016 VIC       0                   0            70920      0    
#>  2  2016 VIC       1                   0            74723      0    
#>  3  2016 VIC       2                   0            74475      0    
#>  4  2016 VIC       3               25354            76009      0.334
#>  5  2016 VIC       4               49763            75084      0.663
#>  6  2016 VIC       5               64489            73468      0.878
#>  7  2016 VIC       6               70717            74780      0.946
#>  8  2016 VIC       7               69543            73391      0.948
#>  9  2016 VIC       8               69673            73373      0.950
#> 10  2016 VIC       9               69894            73627      0.949
#> # ℹ 106 more rows
abs_age_education_state(state = "WA", age = 1:5)
#> # A tibble: 5 × 6
#>    year state   age population_educated total_population proportion
#>   <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
#> 1  2016 WA        1                   0            32754      0    
#> 2  2016 WA        2                   0            32629      0    
#> 3  2016 WA        3                7633            32783      0.233
#> 4  2016 WA        4               26355            32463      0.812
#> 5  2016 WA        5               30743            32910      0.934
abs_age_education_state(state = c("QLD", "TAS"), age = 5)
#> # A tibble: 2 × 6
#>    year state   age population_educated total_population proportion
#>   <dbl> <chr> <dbl>               <dbl>            <dbl>      <dbl>
#> 1  2016 QLD       5               55416            61981      0.894
#> 2  2016 TAS       5                5745             6132      0.937
abs_age_education_lga(lga = c("Albury (C)", "Barcoo (S)"), age = 10)
#> # A tibble: 2 × 8
#>    year state lga          age population_educated total_population proportion
#>   <dbl> <chr> <chr>      <dbl>               <dbl>            <dbl>      <dbl>
#> 1  2016 NSW   Albury (C)    10                 615              654      0.940
#> 2  2016 QLD   Barcoo (S)    10                   7                7      1    
#> # ℹ 1 more variable: anomaly_flag <lgl>
```
