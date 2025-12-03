# Define a conmat population

A conmat population is a dataframe that stores which columns represent
the age and population information. This is useful as it means we can
refer to this information throughout other functions in the conmat
package without needing to specify or hard code which columns represent
the age and population information.

## Usage

``` r
conmat_population(data, age, population)
```

## Arguments

- data:

  data.frame

- age:

  bare name representing the age column

- population:

  bare name representing the population column

## Value

a data frame with age and population attributes

## Examples

``` r
perth <- abs_age_lga("Perth (C)")
```
