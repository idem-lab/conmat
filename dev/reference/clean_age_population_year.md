# Prepare age population data

Internally used function within
[`age_population()`](https://idem-lab.github.io/conmat/dev/reference/age_population.md)
to separate age groups into its lower & upper limit and then filter the
data passed to the desired year and location.

## Usage

``` r
clean_age_population_year(
  data,
  location_col = NULL,
  location = NULL,
  age_col,
  year_col = NULL,
  year = NULL
)
```

## Arguments

- data:

  data.frame

- location_col:

  bare unquoted variable referring to location column

- location:

  location name to filter to. If not specified gives all locations.

- age_col:

  bare unquoted variable referring to age column

- year_col:

  bare unquoted variable referring to year column

- year:

  year to filter to. If not specified, gives all years.

## Value

data frame with `lower.age.limit` and `upper.age.limit` and optionally
filtered down to specific location or year.
