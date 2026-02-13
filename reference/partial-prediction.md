# Create partial predictions and partial prediction plots.

Partial predictions allow you to explore and understand the impact of
each of the covariates used in the conmat GAM model. See 'Details' for
more information.

## Usage

``` r
partial_effects(model, ages, ...)

# S3 method for class 'contact_model'
partial_effects(model, ages, ...)

# S3 method for class 'setting_contact_model'
partial_effects(model, ages, ...)

# S3 method for class 'setting_contact_model'
partial_effects_sum(model, ages, ...)
```

## Arguments

- model:

  A fitted contact model, with class `contact_model` (from
  [`fit_single_contact_model()`](https://idem-lab.github.io/conmat/reference/fit_single_contact_model.md),
  or a simple element from list output of
  [`fit_setting_contacts()`](https://idem-lab.github.io/conmat/reference/fit_setting_contacts.md)),
  e.g. `polymod_setting_models$home`. Or, class
  `setting_contact_model` - a list of fitted contact models (from
  [`fit_setting_contacts()`](https://idem-lab.github.io/conmat/reference/fit_setting_contacts.md))),
  e.g. `polymod_setting_models`.

- ages:

  vector of integer ages.

- ...:

  extra arguments. Currently not used.

## Value

data frame with 20 columns plus n rows based on expand.grid combination
of ages. Contains transformed coefficients from ages.

## Details

Partial predictive plots give a visual representation of the effect of
each covariate on the model, or (equivalently) the effect of each
setting on the total contact matrix. Positive values indicate more
contacts in that region of the matrix compared to the null case, while
negative values indicate less. Essentially, they represent the change in
outcome variable on the **model scale** with a unit change in input
variable.

Scales are not comparable *across* settings, as each setting has it's
own intercept term which is not accounted for in partial effects.

## Examples

``` r
partials_home <- partial_effects(
  polymod_setting_models$home, # Do for all models by omitting $home
  ages = 1:99
  )
```
