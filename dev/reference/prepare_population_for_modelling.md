# Prepare population data for generating an age population function

Prepares objects for use in
[`get_age_population_function()`](https://idem-lab.github.io/conmat/dev/reference/get_age_population_function.md).

## Usage

``` r
prepare_population_for_modelling(data, ...)

# S3 method for class 'conmat_population'
prepare_population_for_modelling(data, ...)

# S3 method for class 'data.frame'
prepare_population_for_modelling(
  data = data,
  age_col = age_col,
  pop_col = pop_col,
  ...
)
```

## Arguments

- data:

  data.frame

- ...:

  extra arguments

- age_col:

  column of ages

- pop_col:

  column of population,

## Value

list of objects, `max_bound` `pop_model_bounded` `bounded_pop`
`unbounded_pop` for use in
[`get_age_population_function()`](https://idem-lab.github.io/conmat/dev/reference/get_age_population_function.md)

## Author

njtierney

## Examples

``` r
prepare_population_for_modelling(get_polymod_population())
#> $max_bound
#> [1] 100
#> 
#> $pop_model_bounded
#> # A tibble: 20 × 5 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lower.age.limit population bin_width midpoint log_pop
#>              <int>      <dbl>     <int>    <dbl>   <dbl>
#>  1               0   1898966.         5      2.5   12.8 
#>  2               5   2017632.         5      7.5   12.9 
#>  3              10   2192410.         5     12.5   13.0 
#>  4              15   2369985.         5     17.5   13.1 
#>  5              20   2467873.         5     22.5   13.1 
#>  6              25   2484327.         5     27.5   13.1 
#>  7              30   2649826.         5     32.5   13.2 
#>  8              35   3043704.         5     37.5   13.3 
#>  9              40   3117812.         5     42.5   13.3 
#> 10              45   2879510.         5     47.5   13.3 
#> 11              50   2605192.         5     52.5   13.2 
#> 12              55   2423464.         5     57.5   13.1 
#> 13              60   2104101.         5     62.5   12.9 
#> 14              65   2109733.         5     67.5   13.0 
#> 15              70   1672763.         5     72.5   12.7 
#> 16              75   1370864.         5     77.5   12.5 
#> 17              80    971960.         5     82.5   12.2 
#> 18              85    404015.         5     87.5   11.3 
#> 19              90    205831.         5     92.5   10.6 
#> 20              95     43561.         5     97.5    9.07
#> 
#> $bounded_pop
#> [1] 39033527
#> 
#> $unbounded_pop
#> [1] 4025.441
#> 
```
