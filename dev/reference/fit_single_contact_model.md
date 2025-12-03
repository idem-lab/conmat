# Fit a single GAM contact model to a dataset

This is the workhorse of the `conmat` package, and is typically used
inside
[`fit_setting_contacts()`](https://idem-lab.github.io/conmat/dev/reference/fit_setting_contacts.md).
It predicts the contact rate between all age bands (the contact rate
between ages 0 and 1, 0 and 2, 0 and 3, and so on), for a specified
setting, with specific terms being added for given settings. See
"details" for further information.

## Usage

``` r
fit_single_contact_model(
  contact_data,
  population,
  symmetrical = TRUE,
  school_demographics = NULL,
  work_demographics = NULL
)
```

## Arguments

- contact_data:

  dataset with columns `age_to`, `age_from`, `setting`, `contacts`, and
  `participants`. See
  [`get_polymod_contact_data()`](https://idem-lab.github.io/conmat/dev/reference/get_polymod_contact_data.md)
  for an example dataset - or the dataset in examples below.

- population:

  `conmat_population` object, or data frame with columns
  `lower.age.limit` and `population`. See
  [`get_polymod_population()`](https://idem-lab.github.io/conmat/dev/reference/get_polymod_population.md)
  for an example.

- symmetrical:

  whether to enforce symmetrical terms in the model. Defaults to TRUE.
  See `details` for more information.

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

single model

## Details

The model fit is a Generalised Additive Model (GAM). We provide two
"modes" for model fitting. Either using "symmetric" or "non-symmetric"
model predictor terms with the logical variance "symmetrical", which is
set to TRUE by default. We recommend using the "symmetrical" terms as it
reflects the fact that contacts are symmetric - person A having contact
with person B means person B has had contact with person A. We've
included a variety of terms to account for assortativity with age, where
people of similar ages have more contact with each other. And included
terms to account for intergenerational contact patterns, where parents
and grandparents will interact with their children and grand children.
These terms are fit with a smoothing function. Specifically, the
relevant code looks like this:

    # abs(age_from - age_to)
    s(gam_age_offdiag) +
    # abs(age_from - age_to)^2
    s(gam_age_offdiag_2) +
    # abs(age_from * age_to)
    s(gam_age_diag_prod) +
    # abs(age_from + age_to)
    s(gam_age_diag_sum) +
    # pmax(age_from, age_to)
    s(gam_age_pmax) +
    # pmin(age_from, age_to)
    s(gam_age_pmin)

We also include predictors for the probability of attending school, and
attending work. These are computed as the probability that a person goes
to the same school/work, proportional to the increase in contacts due to
attendance. These terms are calculated from estimated proportion of
people in age groups attending school and work. See
[`add_modelling_features()`](https://idem-lab.github.io/conmat/dev/reference/add_modelling_features.md)
for more details.

Finally, we include two offset terms so that we estimate the contact
rate, that is the contacts per capita, instead of the number of
contacts. These offset terms are `log(contactable_population)`, and
`log(contactable_population_school)` when the model is fit to a school
setting. The contactable population is estimated as the interpolated 1
year ages from the data. For schools this is the contactable population
weighted by the proportion of the population attending school.

This leaves us with a model that looks like so:

    mgcv::bam(
      formula = contacts ~
        # abs(age_from - age_to)
        s(gam_age_offdiag) +
        # abs(age_from - age_to)^2
        s(gam_age_offdiag_2) +
        # abs(age_from * age_to)
        s(gam_age_diag_prod) +
        # abs(age_from + age_to)
        s(gam_age_diag_sum) +
        # pmax(age_from, age_to)
        s(gam_age_pmax) +
        # pmin(age_from, age_to)
        s(gam_age_pmin) +
        school_probability +
        work_probability +
        offset(log_contactable_population) +
        # or for school settings
        # offset(log_contactable_population_school)
        family = stats::poisson,
      offset = log(participants),
      data = population_data
    )

But if the term `symmetrical = FALSE` is used, you get:

    mgcv::bam(
      formula = contacts ~
        s(age_to) +
        s(age_from) +
        s(abs(age_from - age_to)) +
        s(abs(age_from - age_to), age_from) +
        school_probability +
        work_probability +
        offset(log_contactable_population) +
        # or for school settings
        # offset(log_contactable_population_school)
        family = stats::poisson,
      offset = log(participants),
      data = population_data
    )

## Examples

``` r
example_contact <- get_polymod_contact_data(setting = "home")
example_contact
#> # A tibble: 8,787 × 5
#>    setting age_from age_to contacts participants
#>    <chr>      <int>  <dbl>    <int>        <int>
#>  1 home           0      0       10           92
#>  2 home           0      1        7           92
#>  3 home           0      2       12           92
#>  4 home           0      3       14           92
#>  5 home           0      4       11           92
#>  6 home           0      5        6           92
#>  7 home           0      6        9           92
#>  8 home           0      7        9           92
#>  9 home           0      8        6           92
#> 10 home           0      9        6           92
#> # ℹ 8,777 more rows
example_population <- get_polymod_population()

library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

example_contact_20 <- example_contact %>%
  filter(
    age_to <= 20,
    age_from <= 20
  )

my_mod <- fit_single_contact_model(
  contact_data = example_contact_20,
  population = example_population
)

# you can specify your own population data for school and work demographics
my_mod_diff_data <- fit_single_contact_model(
  contact_data = example_contact_20,
  population = example_population,
  school_demographics = conmat_original_school_demographics,
  work_demographics = conmat_original_work_demographics
)
```
