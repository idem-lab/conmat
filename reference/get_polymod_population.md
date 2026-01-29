# Return the polymod-average population age distribution in 5y

returns the polymod-average population age distribution in 5y increments
(weight country population distributions by number of participants).
Note that we don't want to weight by survey age distributions for this,
since the total number of *participants* represents the sampling. It
uses the participant data from the polymod survey as well as the age
specific population data from `socialmixr` R package to return the age
specific average population of different, countries weighted by the
number of participants from those countries who participated in the
polymod survey.

## Usage

``` r
get_polymod_population(
  countries = c("Belgium", "Finland", "Germany", "Italy", "Luxembourg", "Netherlands",
    "Poland", "United Kingdom")
)
```

## Arguments

- countries:

  countries to extract data from. Default is to get: Belgium, Finland,
  Germany, Italy, Luxembourg, Netherlands, Poland, and United Kingdom.

## Value

A `conmat_population` data frame with two columns: `lower.age.limit` and
`population`

## Examples

``` r
get_polymod_population()
#> # A tibble: 21 × 2 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lower.age.limit population
#>              <int>      <dbl>
#>  1               0   1898966.
#>  2               5   2017632.
#>  3              10   2192410.
#>  4              15   2369985.
#>  5              20   2467873.
#>  6              25   2484327.
#>  7              30   2649826.
#>  8              35   3043704.
#>  9              40   3117812.
#> 10              45   2879510.
#> # ℹ 11 more rows
get_polymod_population("Belgium")
#> # A tibble: 21 × 2 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lower.age.limit population
#>              <int>      <dbl>
#>  1               0     583492
#>  2               5     593148
#>  3              10     632157
#>  4              15     626921
#>  5              20     649588
#>  6              25     663176
#>  7              30     705878
#>  8              35     773177
#>  9              40     823305
#> 10              45     779436
#> # ℹ 11 more rows
get_polymod_population("United Kingdom")
#> # A tibble: 21 × 2 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lower.age.limit population
#>              <int>      <dbl>
#>  1               0    3453670
#>  2               5    3558887
#>  3              10    3826567
#>  4              15    3960166
#>  5              20    3906577
#>  6              25    3755132
#>  7              30    4169859
#>  8              35    4694734
#>  9              40    4655093
#> 10              45    3989175
#> # ℹ 11 more rows
get_polymod_population("Italy")
#> # A tibble: 21 × 2 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lower.age.limit population
#>              <int>      <dbl>
#>  1               0    2758749
#>  2               5    2712790
#>  3              10    2815246
#>  4              15    2917476
#>  5              20    3168918
#>  6              25    3786584
#>  7              30    4553115
#>  8              35    4797005
#>  9              40    4701976
#> 10              45    4136438
#> # ℹ 11 more rows
```
