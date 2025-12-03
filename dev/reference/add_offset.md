# Adds offset variables

Mostly used internally in
[`add_modelling_features()`](https://idem-lab.github.io/conmat/dev/reference/add_modelling_features.md).
Adds two offset variables to be used in
[`fit_single_contact_model()`](https://idem-lab.github.io/conmat/dev/reference/fit_single_contact_model.md):

1.  `log_contactable_population_school`, and

2.  `log_contactable_population`. These two variables require variables
    `school_weighted_pop_fraction` (from
    [`add_school_work_participation()`](https://idem-lab.github.io/conmat/dev/reference/add_school_work_participation.md))
    and `pop_age_to` (from
    [`add_school_work_participation()`](https://idem-lab.github.io/conmat/dev/reference/add_school_work_participation.md)).
    This provides separate offsets for school setting when compared to
    the other settings such as home, work and other. The offset for
    school captures cohorting of students for schools and takes the
    logarithm of the weighted combination of contact population age
    distribution & school year probability calculated in
    [`add_school_work_participation()`](https://idem-lab.github.io/conmat/dev/reference/add_school_work_participation.md).
    See "details" for more information.

## Usage

``` r
add_offset(contact_data)
```

## Arguments

- contact_data:

  contact data - must contain columns `age_to`, `age_from`, `pop_age_to`
  (from
  [`add_population_age_to()`](https://idem-lab.github.io/conmat/dev/reference/add_population_age_to.md),
  and `school_weighted_pop_fraction` (from
  [`add_school_work_participation()`](https://idem-lab.github.io/conmat/dev/reference/add_school_work_participation.md))).

## Value

data.frame of `contact_data` with two extra columns:
`log_contactable_population_school` and `log_contactable_population`

## Details

why double offsets? There are two offsets specified, once in the model
formula, and once in the "offset" argument of
[`mgcv::bam`](https://rdrr.io/pkg/mgcv/man/bam.html). The offsets get
added together when the model first fit. In addition, the setting
specific offset from `offset_variable`, which is included in the GAM
model as `... + offset(log_contactable_population)` is used in
prediction, whereas the other offset, included as an argument in the GAM
as `offset = log(participants)` is only included when the model is
initially created. See more detail in
[`fit_single_contact_model()`](https://idem-lab.github.io/conmat/dev/reference/fit_single_contact_model.md).

## Author

Nick Golding

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
  add_school_work_participation() %>%
  add_offset()
#> # A tibble: 36 × 14
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
#> # ℹ 9 more variables: school_fraction_age_to <dbl>, school_probability <dbl>,
#> #   school_year_probability <dbl>, school_weighted_pop_fraction <dbl>,
#> #   work_fraction_age_from <dbl>, work_fraction_age_to <dbl>,
#> #   work_probability <dbl>, log_contactable_population_school <dbl>,
#> #   log_contactable_population <dbl>
```
