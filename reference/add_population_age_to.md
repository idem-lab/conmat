# Add the population distribution for contact ages.

Adds the population distribution of contact ages. Requires a column
called "age_to", representing the contact age - the age of the person
who had contact. It creates a column, `pop_age_to`. The `population`
argument defaults to
[`get_polymod_population()`](https://idem-lab.github.io/conmat/reference/get_polymod_population.md),
which is a `conmat_population` object, which has `age` and `population`
specified. But this can also be a data frame with columns,
`lower.age.limit`, and `population`. If population is 'polymod' then use
the participant-weighted average of POLYMOD country/year distributions.
It adds the population via interpolation, using
[`get_age_population_function()`](https://idem-lab.github.io/conmat/reference/get_age_population_function.md)
to create a function that generates population from ages.

## Usage

``` r
add_population_age_to(contact_data, population = get_polymod_population())
```

## Arguments

- contact_data:

  contact data containing columns `age_to` and `age_from`

- population:

  Defaults to
  [`get_polymod_population()`](https://idem-lab.github.io/conmat/reference/get_polymod_population.md),
  a `conmat_population` object, which specifies the `age` and
  `population` columns. But it can optionally be any data frame with
  columns, `lower.age.limit`, and `population`.

## Value

data frame of `contact_data` with the number of intergenerational mixing
contacts added.

## Examples

``` r
age_min <- 10
age_max <- 15
all_ages <- age_min:age_max
library(tidyr)
example_df <- expand_grid(
  age_from = all_ages,
  age_to = all_ages,
)
add_population_age_to(example_df)
#> # A tibble: 36 × 4
#>    age_from age_to pop_age_to intergenerational
#>       <int>  <int>      <dbl>             <int>
#>  1       10     10      0.161                 0
#>  2       10     11      0.163                 1
#>  3       10     12      0.165                 2
#>  4       10     13      0.168                 3
#>  5       10     14      0.170                 4
#>  6       10     15      0.173                 5
#>  7       11     10      0.161                 1
#>  8       11     11      0.163                 0
#>  9       11     12      0.165                 1
#> 10       11     13      0.168                 2
#> # ℹ 26 more rows
```
