# Return Australian Bureau of Statistics (ABS) age population data for a given Local Government Area (LGA) or state

Return Australian Bureau of Statistics (ABS) age population data for a
given Local Government Area (LGA) or state

## Usage

``` r
abs_age_lga(lga_name)

abs_age_state(state_name)
```

## Arguments

- lga_name:

  lga name - can be a partial match, e.g., although the official name
  might be "Albury (C)", "Albury" is fine.

- state_name:

  shortened state name

## Value

a `conmat_population` dataset containing: `lga` (or `state`),
`lower.age.limit`, `year`, and `population`.

## Examples

``` r
abs_age_lga(c("Albury (C)", "Fairfield (C)"))
#> # A tibble: 36 × 4 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lga           lower.age.limit  year population
#>    <chr>                   <dbl> <dbl>      <dbl>
#>  1 Albury (C)                  0  2020       3764
#>  2 Fairfield (C)               0  2020      12261
#>  3 Albury (C)                  5  2020       3614
#>  4 Fairfield (C)               5  2020      13093
#>  5 Albury (C)                 10  2020       3369
#>  6 Fairfield (C)              10  2020      13602
#>  7 Albury (C)                 15  2020       3334
#>  8 Fairfield (C)              15  2020      14323
#>  9 Albury (C)                 20  2020       3603
#> 10 Fairfield (C)              20  2020      15932
#> # ℹ 26 more rows
abs_age_state(c("NSW", "VIC"))
#> # A tibble: 36 × 4 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>     year state lower.age.limit population
#>    <dbl> <chr>           <dbl>      <dbl>
#>  1  2020 NSW                 0     495091
#>  2  2020 NSW                 5     512778
#>  3  2020 NSW                10     500881
#>  4  2020 NSW                15     468550
#>  5  2020 NSW                20     540233
#>  6  2020 NSW                25     607891
#>  7  2020 NSW                30     611590
#>  8  2020 NSW                35     582824
#>  9  2020 NSW                40     512803
#> 10  2020 NSW                45     527098
#> # ℹ 26 more rows
```
