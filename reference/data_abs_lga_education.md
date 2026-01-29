# LGA wise ABS education population data on different ages for year 2016

A dataset containing Australian Bureau of Statistics education data by
lga for 2016. The data sourced from 2016 Census - Employment, Income and
Education through TableBuilder have been randomly adjusted by the ABS to
avoid the release of confidential data. As a result of this, there are
some cases where the estimated number of people being educated is higher
than the population of those people. Such cases have been flagged under
the `anomaly_flag` variable.

## Usage

``` r
data_abs_lga_education
```

## Format

A data frame with 64,264 rows and 8 variables:

- year:

  2016, data is based on 2016 Census of Population and Housing.

- state:

  String denoting abbreviated name of state or territory, for example,
  'NSW', 'VIC', and 'QLD'.

- lga:

  String denoting the official name of Local Government Area. For
  example, 'Albury (C).'

- age:

  Ages from 0 to 115.

- population_educated:

  Number of people educated including students with full-time, part-time
  status, as well as the people who mentioned just the type of
  educational institution they attend and not their student status.

- total_population:

  Number depicting the total population belonging to the age.

- proportion:

  Number denoting the measure of the ratio of educated population and
  total population belonging to the age i.e, population_educated /
  total_population

- anomaly_flag:

  Logical variable flagging abnormal observations. E.g., total
  population lesser than population_educated as TRUE.

## Source

Census of Population and Housing, 2016, TableBuilder
