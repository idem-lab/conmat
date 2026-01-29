# State wise ABS education population data on different ages for year 2016

A dataset containing Australian Bureau of Statistics education data by
state for 2016. The data sourced from 2016 Census - Employment, Income
and Education through TableBuilder have been randomly adjusted by the
ABS to avoid the release of confidential data.

## Usage

``` r
data_abs_state_education
```

## Format

A data frame with 1044 rows and 6 variables:

- year:

  2016, as data is from 2016 Census of Population and Housing.

- state:

  String of abbreviated name of state or territory names, e.g., 'NSW',
  'VIC', 'QLD' and so on.

- age:

  Ages from 0 to 115.

- population_educated:

  Number of people educated, including students with full-time,
  part-time status, and people who mentioned only the type of
  educational institution they attend and not their student status.

- total_population:

  Total population belonging to age in a row.

- proportion:

  The ratio of educated population and total population belonging to the
  age i.e, population_educated / total_population

## Source

Census of Population and Housing, 2016, TableBuilder
