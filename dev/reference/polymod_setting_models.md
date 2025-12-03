# Polymod Settings models

A data object containing a list of fitted gam models predicting the
number of contacts in each of the four settings which are
"home","work","school" and "other". For more details on model fitting,
see
[`fit_setting_contacts()`](https://idem-lab.github.io/conmat/dev/reference/fit_setting_contacts.md).
This object has been provided as data to avoid recomputing a relatively
common type of model for use with `conmat`.

## Usage

``` r
polymod_setting_models
```

## Format

An object of class `setting_contact_model` (inherits from `list`) of
length 4.

## See also

[`fit_setting_contacts()`](https://idem-lab.github.io/conmat/dev/reference/fit_setting_contacts.md)

## Examples

``` r
# \donttest{
# code used to produce this data
library(conmat)
set.seed(2025 - 11 - 28)
polymod_contact_data <- get_polymod_setting_data()
polymod_survey_data <- get_polymod_population()
polymod_setting_models <- fit_setting_contacts(
  contact_data_list = polymod_contact_data,
  population = polymod_survey_data
)
#> Warning: algorithm did not converge
#> Warning: fitted rates numerically 0 occurred
#> Warning: algorithm did not converge
#> Warning: fitted rates numerically 0 occurred
# }
```
