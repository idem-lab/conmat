# Add columns describing the fractions of the population in each age group that attend school/work (average FTE)

Add fractions of the population in each age group that attend
school/work (average FTE) to compute the probability that both
participant and contact attend school/work. Requires columns `age_to`
and `age_from`. Note that it will operate on any column starting with
`age`. Adds columns: `school_probability`, `work_probability`,
`school_year_probability`, and `school_weighted_pop_fraction`. The
columns `school_probability` and `work_probability` represent the
probability a person of the other age goes to the same work/school.
`school_year_probability` represents the probability that a person of
the other age would be in the same school year.
`school_weighted_pop_fraction` represents the weighted combination of
contact population age distribution & school year probability, so that
if the contact is in the same school year, the weight is 1, and
otherwise it is the population age fraction. This can be used as an
offset, so that population age distribution can be used outside the
classroom, but does not affect classroom contacts (which due to
cohorting and regularised class sizes are unlikely to depend on the
population age distribution).

## Usage

``` r
add_school_work_participation(
  contact_data,
  school_demographics = NULL,
  work_demographics = NULL
)
```

## Arguments

- contact_data:

  contact data containing columns: `age_to`, `age_from`, and
  `pop_age_to` (from
  [`add_population_age_to()`](https://idem-lab.github.io/conmat/reference/add_population_age_to.md))

- school_demographics:

  (optional) defaults to census average proportion at school. You can
  provide a dataset with columns, "age" (numeric), and "school_fraction"
  (0-1), if you would like to specify these details. See
  `abs_avg_school` for the default values. If you would like to use the
  original school demographics used in conmat, these are provided in the
  dataset, `conmat_original_school_demographics`.

- work_demographics:

  (optional) defaults to census average proportion employed. You can
  provide a dataset with columns, "age" (numeric), and "work_fraction",
  if you would like to specify these details. See `abs_avg_work` for the
  default values. If you would like to use the original work
  demographics used in conmat, these are provided in the dataset,
  `conmat_original_work_demographics`.

## Value

dataset with 9 extra columns: school_fraction_age_from,
work_fraction_age_from, school_fraction_age_to, work_fraction_age_to,
school_probability, work_probability, school_year_probability, and
school_weighted_pop_fraction.

## Note

To use previous approach input the arguments `school_demographics` and
`work_demographics` with `conmat_original_school_demographics` and
`conmat_original_work_demographics`, respectively.

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

example_df %>%
  add_population_age_to() %>%
  add_school_work_participation()
#> # A tibble: 36 × 12
#>    age_from age_to pop_age_to intergenerational school_fraction_age_from
#>       <dbl>  <dbl>      <dbl>             <int>                    <dbl>
#>  1       10     10      0.161                 0                    0.922
#>  2       10     11      0.163                 1                    0.922
#>  3       10     12      0.165                 2                    0.922
#>  4       10     13      0.168                 3                    0.922
#>  5       10     14      0.170                 4                    0.922
#>  6       10     15      0.173                 5                    0.922
#>  7       11     10      0.161                 1                    0.931
#>  8       11     11      0.163                 0                    0.931
#>  9       11     12      0.165                 1                    0.931
#> 10       11     13      0.168                 2                    0.931
#> # ℹ 26 more rows
#> # ℹ 7 more variables: school_fraction_age_to <dbl>, school_probability <dbl>,
#> #   school_year_probability <dbl>, school_weighted_pop_fraction <dbl>,
#> #   work_fraction_age_from <dbl>, work_fraction_age_to <dbl>,
#> #   work_probability <dbl>

example_df %>%
  add_population_age_to() %>%
  add_school_work_participation(
    school_demographics = conmat_original_school_demographics,
    work_demographics = conmat_original_work_demographics
  )
#> # A tibble: 36 × 12
#>    age_from age_to pop_age_to intergenerational school_fraction_age_from
#>       <int>  <int>      <dbl>             <int>                    <dbl>
#>  1       10     10      0.161                 0                        1
#>  2       10     11      0.163                 1                        1
#>  3       10     12      0.165                 2                        1
#>  4       10     13      0.168                 3                        1
#>  5       10     14      0.170                 4                        1
#>  6       10     15      0.173                 5                        1
#>  7       11     10      0.161                 1                        1
#>  8       11     11      0.163                 0                        1
#>  9       11     12      0.165                 1                        1
#> 10       11     13      0.168                 2                        1
#> # ℹ 26 more rows
#> # ℹ 7 more variables: school_fraction_age_to <dbl>, school_probability <dbl>,
#> #   school_year_probability <dbl>, school_weighted_pop_fraction <dbl>,
#> #   work_fraction_age_from <dbl>, work_fraction_age_to <dbl>,
#> #   work_probability <dbl>
```
