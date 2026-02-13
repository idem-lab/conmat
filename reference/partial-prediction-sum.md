# Create partial predictive plots for a set of fitted models.

These helper functions exist to make it easier to explore and understand
the impact of each of the covariates used in the conmat GAM model.

## Usage

``` r
partial_effects_sum(model, ages, ...)

# S3 method for class 'contact_model'
partial_effects_sum(model, ages, ...)
```

## Arguments

- model:

  A fitted model, or list of fitted models

- ages:

  vector of integer ages

- ...:

  dots for future extension. Currently not used.

## Value

data frame with 3 columns plus n rows based on expand.grid combination
of ages. The column `gam_total_term` is the sum over the coefficients
for that age bracket.

## Details

Partial predictive plots give a visual representation of the effect of
each covariate on the model, or (equivalently) the effect of each
setting on the total contact matrix. Positive values indicate more
contacts in that region of the matrix compared to the null case, while
negative values indicate less.

Scales are not comparable *across* settings, as each setting has it's
own intercept term, which is not accounted for in partial effects.

## Examples

``` r
# summed up partial effects (y-hat) for all settings
partials_summed_setting <- partial_effects_sum(
    polymod_setting_models, # can also do for one setting with $home
    ages = 1:99
  )
autoplot(partials_summed_setting)
```
