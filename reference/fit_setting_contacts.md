# Fit a contact model to a survey population

fits a gam model for each setting on the survey population data & the
setting wise contact data. The underlying method is described in more
detail in
[`fit_single_contact_model()`](https://idem-lab.github.io/conmat/reference/fit_single_contact_model.md).
The models can be fit in parallel, see the examples. Note that this
function is parallelisable with `future`, and will be impacted by any
`future` plans provided.

## Usage

``` r
fit_setting_contacts(
  contact_data_list,
  population,
  symmetrical = TRUE,
  school_demographics = NULL,
  work_demographics = NULL
)
```

## Arguments

- contact_data_list:

  A list of dataframes, each containing information on the setting
  (home, work, school, other), age_from, age_to, the number of contacts,
  and the number of participants. Example data can be retrieved with
  [`get_polymod_setting_data()`](https://idem-lab.github.io/conmat/reference/get_polymod_setting_data.md).

- population:

  `conmat_population` object or dataset with columns `lower.age.limit`
  and `population`. Example data can be retrieved with
  [`get_polymod_population()`](https://idem-lab.github.io/conmat/reference/get_polymod_population.md).

- symmetrical:

  whether to enforce symmetrical terms in the model. Defaults to TRUE.
  See `details` of `fit_single_contact_model` for more information.

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

list of fitted gam models - one for each setting provided

## Author

Nicholas Tierney

## Examples

``` r
# These aren't being  run as they take too long to fit
# \donttest{
contact_model <- fit_setting_contacts(
  contact_data_list = get_polymod_setting_data(),
  population = get_polymod_population()
)
#> Warning: fitted rates numerically 0 occurred
#> Warning: fitted rates numerically 0 occurred

# can fit the model in parallel
library(future)
plan(multisession, workers = 4)

polymod_setting_data <- get_polymod_setting_data()
polymod_population <- get_polymod_population()

contact_model <- fit_setting_contacts(
  contact_data_list = polymod_setting_data,
  population = polymod_population
)
#> Warning: fitted rates numerically 0 occurred

# you can specify your own population data for school and work demographics
contact_model_diff_data <- fit_setting_contacts(
  contact_data_list = polymod_setting_data,
  population = polymod_population,
  school_demographics = conmat_original_school_demographics,
  work_demographics = conmat_original_work_demographics
)
#> Warning: fitted rates numerically 0 occurred
# Shut down parallel workers
future::plan("sequential")
# }
```
