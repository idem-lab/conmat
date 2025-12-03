# Add features required for modelling to the dataset

This function adds three main groups of features to the data. It is used
internally in
[`fit_single_contact_model()`](https://idem-lab.github.io/conmat/dev/reference/fit_single_contact_model.md)
and
[`predict_contacts_1y()`](https://idem-lab.github.io/conmat/dev/reference/predict_contacts_1y.md).
It requires columns named `age_to` and `age_from`. The three types of
features it adds are described below:

1.  Population distribution of contact ages from the function
    [`add_population_age_to()`](https://idem-lab.github.io/conmat/dev/reference/add_population_age_to.md),
    which requires a column called "age_to" representing the age of the
    person who had contact. It creates a column called `pop_age_to`.
    [`add_population_age_to()`](https://idem-lab.github.io/conmat/dev/reference/add_population_age_to.md)
    takes an extra argument for population, which defaults to
    [`get_polymod_population()`](https://idem-lab.github.io/conmat/dev/reference/get_polymod_population.md),
    but needs to be a `conmat_population` object, which specifies the
    `age` and `population` characteristics, or a data frame with
    columns, `lower.age.limit`, and `population`.

2.  School work participation, which is from the function
    [`add_school_work_participation()`](https://idem-lab.github.io/conmat/dev/reference/add_school_work_participation.md).
    This requires columns `age_to` and `age_from`, but will operate on
    any column starting with `age` and adds columns:
    `school_probability`, `work_probability`, `school_year_probability`,
    and `school_weighted_pop_fraction`.

3.  Offset is added on to the data using
    [`add_offset()`](https://idem-lab.github.io/conmat/dev/reference/add_offset.md).
    This requires variables `school_weighted_pop_fraction` (from
    [`add_school_work_participation()`](https://idem-lab.github.io/conmat/dev/reference/add_school_work_participation.md))
    and `pop_age_to` (from
    [`add_school_work_participation()`](https://idem-lab.github.io/conmat/dev/reference/add_school_work_participation.md)).
    It adds two columns, `log_contactable_population_school`, and
    `log_contactable_population`.

## Usage

``` r
add_modelling_features(
  contact_data,
  school_demographics = NULL,
  work_demographics = NULL,
  population = get_polymod_population()
)
```

## Arguments

- contact_data:

  contact data with columns `age_to` and `age_from`

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

- population:

  the `population` argument of
  [`add_population_age_to()`](https://idem-lab.github.io/conmat/dev/reference/add_population_age_to.md)

## Value

data frame with 11 extra columns - the contents of `contact_data`, plus:
pop_age_to, school_fraction_age_from, work_fraction_age_from,
school_fraction_age_to, work_fraction_age_to, school_probability,
work_probability, school_year_probability, school_weighted_pop_fraction,
log_contactable_population_school, and log_contactable_population.

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
add_modelling_features(example_df)
add_modelling_features(
  example_df,
  school_demographics = conmat_original_school_demographics,
  work_demographics = conmat_original_work_demographics
)
```
