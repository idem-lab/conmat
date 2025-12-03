# Separate age groups

An internal function used within
[`clean_age_population_year()`](https://idem-lab.github.io/conmat/dev/reference/clean_age_population_year.md)
to separate age groups in a data set into two variables,
`lower.age.limit`, and `upper.age.limit`

## Usage

``` r
separate_age_group(data, age_col)
```

## Arguments

- data:

  data frame

- age_col:

  bare unquoted column referring to age column

## Value

data frame with two extra columns, `lower.age.limit` and
`upper.age.limit`
