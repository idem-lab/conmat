# Convert to conmat population

Convert to conmat population

## Usage

``` r
as_conmat_population(data, ...)

# Default S3 method
as_conmat_population(data, ...)

# S3 method for class 'data.frame'
as_conmat_population(data, age, population, ...)

# S3 method for class 'list'
as_conmat_population(data, age, population, ...)

# S3 method for class 'grouped_df'
as_conmat_population(data, age, population, ...)
```

## Arguments

- data:

  data.frame

- ...:

  extra arguments

- age:

  age column - an unquoted variable of numeric integer ages

- population:

  population column - an unquoted variable, numeric value

## Value

Creates conmat population object, which knows about its age, position,
and population.

## Examples

``` r
some_age_pop <- data.frame(
  age = 1:10,
  pop = 101:110
)

some_age_pop
#>    age pop
#> 1    1 101
#> 2    2 102
#> 3    3 103
#> 4    4 104
#> 5    5 105
#> 6    6 106
#> 7    7 107
#> 8    8 108
#> 9    9 109
#> 10  10 110

as_conmat_population(
  some_age_pop,
  age = age,
  population = pop
)
#> # A tibble: 10 × 2 (conmat_population)
#>  - age: age
#>  - population: pop
#>      age   pop
#>    <int> <int>
#>  1     1   101
#>  2     2   102
#>  3     3   103
#>  4     4   104
#>  5     5   105
#>  6     6   106
#>  7     7   107
#>  8     8   108
#>  9     9   109
#> 10    10   110
```
