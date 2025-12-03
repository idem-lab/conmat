# Accessing conmat attributes

Accessing conmat attributes

## Usage

``` r
age(x)

age_label(x)

# Default S3 method
age_label(x)

# S3 method for class 'conmat_population'
age_label(x)

population_label(x)

# Default S3 method
population_label(x)

# S3 method for class 'conmat_population'
population_label(x)

population(x)
```

## Arguments

- x:

  conmat_population data frame

## Value

age or population symbol or label

## Examples

``` r
perth <- abs_age_lga("Perth (C)")
age(perth)
#> lower.age.limit
age_label(perth)
#> [1] "lower.age.limit"
population(perth)
#> population
population_label(perth)
#> [1] "population"
```
